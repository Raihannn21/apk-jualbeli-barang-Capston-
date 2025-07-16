<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Helper function untuk menambahkan data agregat ke query.
     * Ini untuk menghindari pengulangan kode.
     */
    private function addProductAggregates($query)
    {
        return $query->withCount('reviews') // kolom 'reviews_count'
            ->withAvg('reviews', 'rating') // 'reviews_avg_rating'
            ->withCount(['orderItems as sold_count' => function ($q) {
                $q->whereHas('order', function ($subq) {
                    $subq->whereIn('status', ['completed', 'paid', 'shipped']);
                });
            }]);
    }

    /**
     * Menampilkan daftar semua produk.
     */
    public function index(Request $request)
    {
        $query = Product::query()->with('category');

        if ($request->has('category') && $request->category != '') {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->category);
            });
        }

        // Terapkan agregat ke query
        $query = $this->addProductAggregates($query);

        $products = $query->latest()->get()->map(function ($product) {
            $product->image_url = $product->image ? asset('uploads/' . $product->image) : null;
            return $product;
        });

        return response()->json(['success' => true, 'data' => $products]);
    }

    /**
     * Menampilkan detail satu produk.
     */
    public function show(Product $product)
    {
        // Muat data agregat untuk satu produk
        $product->loadCount('reviews');
        $product->loadAvg('reviews', 'rating');
        $product->loadCount(['orderItems as sold_count' => function ($q) {
            $q->whereHas('order', function ($subq) {
                $subq->whereIn('status', ['completed', 'paid', 'shipped']);
            });
        }]);

        $product->load('images');

        if ($product->image) {
            $product->image_url = asset('uploads/' . $product->image);
        } else {
            $product->image_url = null;
        }

        foreach ($product->images as $image) {
            $image->image_url = asset('uploads/' . $image->image_path);
        }

        return response()->json(['success' => true, 'data' => $product]);
    }

    /**
     * Mencari produk berdasarkan nama.
     */
    public function search(Request $request)
    {
        $request->validate(['q' => 'required|string']);
        $query = trim($request->q);

        $sortedProducts = Product::all()->sortBy('name', SORT_NATURAL | SORT_FLAG_CASE)->values();

        $low = 0;
        $high = $sortedProducts->count() - 1;
        $result = null;

        while ($low <= $high) {
            $mid = (int)floor($low + ($high - $low) / 2);
            $midProduct = $sortedProducts[$mid];

            $midProductName = trim($midProduct->name);
            $comparison = strcasecmp($midProductName, $query);

            if ($comparison == 0) {
                $result = $midProduct;
                break;
            }

            if ($comparison < 0) {
                $low = $mid + 1;
            } else {
                $high = $mid - 1;
            }
        }

        if ($result) {
            if ($result->image) {
                $result->image_url = asset('uploads/' . $result->image);
            } else {
                $result->image_url = null;
            }
            return response()->json(['data' => [$result]]);
        }

        return response()->json(['data' => []]);
    }
    public function latest()
    {
        $products = Product::latest()->take(8)->get()->map(function ($product) {
            if ($product->image) {
                $product->image_url = asset('uploads/' . $product->image);
            } else {
                $product->image_url = null;
            }
            return $product;
        });

        return response()->json([
            'success' => true,
            'data' => $products,
        ]);
    }
}
