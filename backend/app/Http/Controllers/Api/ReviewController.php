<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ReviewController extends Controller
{
    /**
     * Menampilkan daftar semua ulasan untuk sebuah produk.
     * Ini adalah endpoint publik yang bisa diakses siapa saja.
     */
    public function index(Product $product)
    {
        // Ambil ulasan, sertakan data user (hanya id dan nama)
        // Urutkan dari yang terbaru dan gunakan pagination
        $reviews = $product->reviews()
            ->with('user:id,name')
            ->latest()
            ->paginate(10);

        return response()->json([
            'success' => true,
            'data' => $reviews
        ]);
    }

    /**
     * Menyimpan ulasan baru untuk sebuah produk.
     * Endpoint ini memerlukan autentikasi.
     */
    public function store(Request $request, Product $product)
    {
        // 1. Validasi input dari pengguna
        $validated = $request->validate([
            'order_id' => 'required|exists:orders,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        // 2. Cek keamanan: Pastikan pesanan ini memang milik user yang sedang login
        $order = $request->user()->orders()->find($validated['order_id']);
        if (!$order) {
            return response()->json(['message' => 'Anda tidak memiliki akses ke pesanan ini.'], 403);
        }

        // 3. Cek keamanan: Pastikan produk yang direview ada di dalam pesanan tersebut
        $productInOrder = $order->items()->where('product_id', $product->id)->exists();
        if (!$productInOrder) {
            return response()->json(['message' => 'Produk ini tidak ada dalam pesanan Anda.'], 422);
        }
        
        // 4. Cek duplikasi: Pastikan user belum pernah mereview produk ini dari order yang sama
        $existingReview = $product->reviews()
            ->where('user_id', $request->user()->id)
            ->where('order_id', $validated['order_id'])
            ->exists();

        if ($existingReview) {
            return response()->json(['message' => 'Anda sudah memberikan ulasan untuk produk ini dari pesanan tersebut.'], 422);
        }

        // 5. Jika semua pengecekan lolos, buat ulasan baru
        $review = $product->reviews()->create([
            'user_id' => $request->user()->id,
            'order_id' => $validated['order_id'],
            'rating' => $validated['rating'],
            'comment' => $validated['comment'],
        ]);

        // 6. Kembalikan response sukses beserta data ulasan yang baru dibuat
        return response()->json([
            'success' => true,
            'message' => 'Ulasan berhasil ditambahkan.',
            'data' => $review->load('user:id,name'),
        ], 201);
    }
}