<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\ProductReview;
use App\Models\Product;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index(Request $request)
    {
        $products = Product::withCount('reviews')->orderBy('name')->get();
        
        $query = ProductReview::with(['user:id,name,email', 'product:id,name']);
        
        if ($request->filled('product_id')) {
            $query->where('product_id', $request->product_id);
        }
        
        $reviews = $query->latest()->paginate(15);
        
        $statsQuery = ProductReview::query();
        if ($request->filled('product_id')) {
            $statsQuery->where('product_id', $request->product_id);
        }
        
        $totalReviews = $statsQuery->count();
        $averageRating = $statsQuery->avg('rating') ?: 0;
        $highRatings = $statsQuery->where('rating', '>=', 4)->count();
        $lowRatings = $statsQuery->where('rating', '<=', 2)->count();
        
        $selectedProductId = $request->input('product_id');
            
        return view('admin.reviews.index', compact('reviews', 'products', 'selectedProductId', 'totalReviews', 'averageRating', 'highRatings', 'lowRatings'));
    }
    public function destroy(ProductReview $review)
    {
        $review->delete();

        return redirect()->route('admin.reviews.index')->with('success', 'Ulasan berhasil dihapus.');
    }
}