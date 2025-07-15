<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'user_address_id',
        'shipping_cost',
        'shipping_courier',
        'total_amount',
        'status',
        'payment_proof',
        'payment_method',
        // 'courier_code',
        // 'waybill_number',
        'subtotal',
        'discount_amount',
        'payment_token',   
        'payment_url',
    ];
    /**
     * Get the user that owns the order.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get all of the items for the order.
     */
    public function items()
    {
        return $this->hasMany(OrderItem::class);
    }
    public function address()
    {
        return $this->belongsTo(UserAddress::class, 'user_address_id');
    }
}
