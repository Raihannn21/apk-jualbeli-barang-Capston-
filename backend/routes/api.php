<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AddressController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\LocationController;
use App\Http\Controllers\Api\OrderController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\ReviewController;
use App\Http\Controllers\Api\ShippingController;
use App\Http\Controllers\Api\PaymentController;
use App\Http\Controllers\Api\MidtransWebhookController;

/*
|--------------------------------------------------------------------------
| Rute Publik (Tidak Perlu Login)
|--------------------------------------------------------------------------
*/

// --- AUTH ---
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// --- PRODUK, KATEGORI & Ulasan (Publik) ---
Route::get('/products/search', [ProductController::class, 'search']);
Route::get('/products/latest', [ProductController::class, 'latest']);
Route::get('/products/{product}/reviews', [ReviewController::class, 'index']);
Route::apiResource('/products', ProductController::class)->only(['index', 'show']);
Route::apiResource('/categories', CategoryController::class)->only(['index', 'show']);

// --- LOKASI (RAJAONGKIR) ---
Route::get('/locations/search', [LocationController::class, 'search']);

Route::post('/midtrans-notification', [MidtransWebhookController::class, 'handle']);


/*
|--------------------------------------------------------------------------
| Rute Terproteksi (Wajib Login dengan Sanctum)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    // --- AUTH ---
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // --- KERANJANG BELANJA (Didefinisikan manual untuk mengatasi masalah parameter) ---
    Route::get('/cart', [CartController::class, 'index']);
    Route::post('/cart', [CartController::class, 'store']);
    Route::put('/cart/{cartItem}', [CartController::class, 'update']);
    Route::delete('/cart/{cartItem}', [CartController::class, 'destroy']);

    // --- ALAMAT ---
    Route::apiResource('/addresses', AddressController::class);

    // --- PENGIRIMAN (SHIPPING) ---
    Route::post('/shipping-cost', [ShippingController::class, 'checkCost']);

    // --- PESANAN & TRANSAKSI ---
    Route::post('/orders/{order}/confirm-delivery', [OrderController::class, 'confirmDelivery']);
    Route::post('/orders/{order}/cancel', [OrderController::class, 'cancel']);
    Route::post('/orders/{order}/upload-proof', [OrderController::class, 'uploadPaymentProof']);
    Route::apiResource('/orders', OrderController::class)->only(['index', 'store', 'show']);

    Route::get('/orders/{order}/track', [OrderController::class, 'track']);

    Route::post('/orders/{order}/payment', [PaymentController::class, 'createTransaction']);

    // --- Ulasan (Aksi) ---
    Route::post('/products/{product}/reviews', [ReviewController::class, 'store']);
});
