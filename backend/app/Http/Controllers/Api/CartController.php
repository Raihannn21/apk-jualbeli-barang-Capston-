<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Product;
use App\Models\CartItem;

class CartController extends Controller
{
    /**
     * Menampilkan isi keranjang belanja milik user yang terautentikasi.
     */
    public function index(Request $request)
    {
        $cartItems = $request->user()->cartItems()->with('product')->get();

        $cartItems->transform(function ($item) {
            if ($item->product) {
                $item->product->image_url = asset('uploads/' . $item->product->image);
            }
            return $item;
        });

        return response()->json([
            'success' => true,
            'data' => $cartItems
        ]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $user = $request->user();
        $productId = $request->product_id;
        $quantity = $request->quantity;

        $product = Product::find($productId);
        if ($product->stock < $quantity) {
            return response()->json(['message' => 'Stok tidak mencukupi.'], 400);
        }

        $cartItem = $user->cartItems()->where('product_id', $productId)->first();

        if ($cartItem) {
            $cartItem->quantity += $quantity;
            $cartItem->save();
        } else {
            $user->cartItems()->create([
                'product_id' => $productId,
                'quantity' => $quantity,
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Produk berhasil ditambahkan ke keranjang.',
        ], 201);
    }

    public function update(Request $request, CartItem $cartItem)
    {
        if ($request->user()->id !== $cartItem->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validator = Validator::make($request->all(), [
            'quantity' => 'required|integer|min:1',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        if ($cartItem->product->stock < $request->quantity) {
            return response()->json(['message' => 'Stok tidak mencukupi.'], 400);
        }

        $cartItem->update(['quantity' => $request->quantity]);

        return response()->json([
            'success' => true,
            'message' => 'Jumlah item berhasil diperbarui.',
            'data' => $cartItem
        ]);
    }

    public function destroy(Request $request, CartItem $cartItem)
    {
        if ($request->user()->id !== $cartItem->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $cartItem->delete();

        return response()->json([
            'success' => true,
            'message' => 'Item berhasil dihapus dari keranjang.'
        ]);
    }
}