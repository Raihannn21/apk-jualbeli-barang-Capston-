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
        $validated = $request->validate([
            'order_id' => 'required|exists:orders,id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string|max:1000',
        ]);

        $order = $request->user()->orders()->find($validated['order_id']);
        if (!$order) {
            return response()->json(['message' => 'Anda tidak memiliki akses ke pesanan ini.'], 403);
        }

        $productInOrder = $order->items()->where('product_id', $product->id)->exists();
        if (!$productInOrder) {
            return response()->json(['message' => 'Produk ini tidak ada dalam pesanan Anda.'], 422);
        }
        
        $existingReview = $product->reviews()
            ->where('user_id', $request->user()->id)
            ->where('order_id', $validated['order_id'])
            ->exists();

        if ($existingReview) {
            return response()->json(['message' => 'Anda sudah memberikan ulasan untuk produk ini dari pesanan tersebut.'], 422);
        }

        $review = $product->reviews()->create([
            'user_id' => $request->user()->id,
            'order_id' => $validated['order_id'],
            'rating' => $validated['rating'],
            'comment' => $validated['comment'],
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Ulasan berhasil ditambahkan.',
            'data' => $review->load('user:id,name'),
        ], 201);
    }
}