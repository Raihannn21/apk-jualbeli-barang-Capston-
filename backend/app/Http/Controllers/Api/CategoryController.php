<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::all()->map(function ($category) {
            if ($category->image) {
                $category->image_url = asset('uploads/' . $category->image);
            }
            return $category;
        });
        return response()->json([
            'success' => true,
            'data' => $categories,
        ]);
    }
}
