<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserAddress;
use Illuminate\Http\Request;

class AddressController extends Controller
{
    /**
     * Menampilkan daftar semua alamat milik user yang login.
     */
    public function index(Request $request)
    {
        $addresses = $request->user()->addresses()->latest()->get();
        return response()->json(['data' => $addresses]);
    }

    /**
     * Menyimpan alamat baru.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'city_id' => 'required|string',
            'label' => 'required|string|max:255',
            'recipient_name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string',
            'city' => 'required|string',
            'province' => 'required|string',
            'postal_code' => 'required|string|max:10',
            'is_primary' => 'nullable|boolean',
        ]);

        // Jika alamat baru ini adalah alamat utama, nonaktifkan yang lain.
        if ($request->is_primary) {
            $request->user()->addresses()->update(['is_primary' => false]);
        }

        $address = $request->user()->addresses()->create($validated);

        return response()->json([
            'message' => 'Alamat berhasil ditambahkan.',
            'data' => $address
        ], 201);
    }

    /**
     * Menampilkan detail satu alamat.
     */
    public function show(Request $request, UserAddress $address)
    {
        // Pastikan user hanya bisa melihat alamatnya sendiri
        if ($request->user()->id !== $address->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }
        return response()->json(['data' => $address]);
    }

    /**
     * Memperbarui alamat yang sudah ada.
     */
    public function update(Request $request, UserAddress $address)
    {
        // Pastikan user hanya bisa mengubah alamatnya sendiri
        if ($request->user()->id !== $address->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'city_id' => 'required|string',
            'label' => 'required|string|max:255',
            'recipient_name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'address' => 'required|string',
            'city' => 'required|string',
            'province' => 'required|string',
            'postal_code' => 'required|string|max:10',
            'is_primary' => 'nullable|boolean',
        ]);

        if ($request->is_primary) {
            $request->user()->addresses()->update(['is_primary' => false]);
        }

        $address->update($validated);

        return response()->json([
            'message' => 'Alamat berhasil diperbarui.',
            'data' => $address
        ]);
    }

    /**
     * Menghapus alamat.
     */
    public function destroy(Request $request, UserAddress $address)
    {
        // Pastikan user hanya bisa menghapus alamatnya sendiri
        if ($request->user()->id !== $address->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $address->delete();

        return response()->json(['message' => 'Alamat berhasil dihapus.']);
    }
}
