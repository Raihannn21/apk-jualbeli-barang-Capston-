<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserAddress extends Model
{
    protected $fillable = [
        'user_id',
        'city_id',
        'label',
        'recipient_name',
        'phone_number',
        'address',
        'city',
        'province',
        'postal_code',
        'is_primary',
    ];
    public function user() 
    { 
        return $this->belongsTo(User::class);
    }
    public function orders() 
    {
        return $this->hasMany(Order::class, 'user_address_id');
    }
}
