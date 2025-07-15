<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'category_id',
        'description',
        'price',
        'stock',
        'image',
        'discount_price',
        'discount_percent',
        'weight',
    ];
    public function reviews()
    {
        return $this->hasMany(ProductReview::class);
    }
    public function category() 
    { 
        return $this->belongsTo(Category::class); 
    }
    public function images()
    {
        return $this->hasMany(ProductImage::class);
    }
    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}