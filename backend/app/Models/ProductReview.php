<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductReview extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'product_id',
        'order_id',
        'rating',
        'comment',
    ];

    /**
     * Mendapatkan user yang memberikan ulasan.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function reviews()
    {
        return $this->hasMany(ProductReview::class);
    }
    /**
     * Mendapatkan produk yang diulas.
     */
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}