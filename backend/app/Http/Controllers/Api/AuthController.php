<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Carbon;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user
        ], 201);
    }

    public function login(Request $request)
    {
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json(['message' => 'Invalid login details'], 401);
        }

        $user = User::where('email', $request['email'])->firstOrFail();

        // --- LOGIKA STREAK DIMULAI DI SINI ---
        $today = Carbon::today();
        $lastLogin = $user->last_login_at;

        if ($lastLogin) {
            // Jika login terakhir adalah kemarin, tambahkan streak
            if ($lastLogin->isYesterday()) {
                $user->increment('login_streak');
            }
            // Jika login terakhir bukan hari ini (dan bukan kemarin), reset streak
            else if (!$lastLogin->isToday()) {
                $user->login_streak = 1;
            }
        } else {
            // Jika ini login pertama kali
            $user->login_streak = 1;
        }

        // Perbarui tanggal login terakhir ke hari ini
        $user->last_login_at = Carbon::now();
        $user->save();
        // --- LOGIKA STREAK SELESAI ---

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user->fresh(), // Kirim data user yang sudah di-update
        ]);
    }
    // app/Http/Controllers/Api/AuthController.php

    public function logout(Request $request)
    {
        // Ambil user yang terotentikasi
        $user = $request->user();

        // Hapus semua token milik user tersebut. Ini lebih aman.
        $user->tokens()->delete();

        // Kembalikan response sukses
        return response()->json([
            'success' => true,
            'message' => 'Successfully logged out'
        ]);
    }
}
