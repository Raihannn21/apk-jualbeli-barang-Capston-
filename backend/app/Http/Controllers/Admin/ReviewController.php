<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProductReview; // <-- Tambahkan import
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        // Ambil ulasan, sertakan data user & produk, urutkan, paginasi
        $reviews = ProductReview::with(['user:id,name', 'product:id,name'])
            ->latest()
            ->paginate(15);
            
        return view('admin.reviews.index', compact('reviews'));
    }
    public function destroy(ProductReview $review)
    {
        $review->delete();

        return redirect()->route('admin.reviews.index')->with('success', 'Ulasan berhasil dihapus.');
    }
}