<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProductReview; // <-- Tambahkan import
use App\Models\Product;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index(Request $request)
    {
        // Ambil semua produk untuk dropdown (termasuk yang belum ada review)
        $products = Product::withCount('reviews')->orderBy('name')->get();
        
        // Filter berdasarkan produk jika dipilih
        $query = ProductReview::with(['user:id,name,email', 'product:id,name']);
        
        if ($request->filled('product_id')) {
            $query->where('product_id', $request->product_id);
        }
        
        // Ambil ulasan, sertakan data user & produk, urutkan, paginasi
        $reviews = $query->latest()->paginate(15);
        
        // Hitung statistik berdasarkan filter
        $statsQuery = ProductReview::query();
        if ($request->filled('product_id')) {
            $statsQuery->where('product_id', $request->product_id);
        }
        
        $totalReviews = $statsQuery->count();
        $averageRating = $statsQuery->avg('rating') ?: 0;
        $highRatings = $statsQuery->where('rating', '>=', 4)->count();
        $lowRatings = $statsQuery->where('rating', '<=', 2)->count();
        
        // Simpan product_id yang dipilih untuk view
        $selectedProductId = $request->input('product_id');
            
        return view('admin.reviews.index', compact('reviews', 'products', 'selectedProductId', 'totalReviews', 'averageRating', 'highRatings', 'lowRatings'));
    }
    public function destroy(ProductReview $review)
    {
        $review->delete();

        return redirect()->route('admin.reviews.index')->with('success', 'Ulasan berhasil dihapus.');
    }
}