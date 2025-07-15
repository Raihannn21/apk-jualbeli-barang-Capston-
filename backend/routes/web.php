<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\ReviewController;
use App\Http\Controllers\Admin\UserController;
use App\Http\Controllers\Admin\SettingController;


/*
|--------------------------------------------------------------------------
| Rute Publik
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return view('welcome');
});


/*
|--------------------------------------------------------------------------
| Rute Pengguna Terotentikasi (Breeze Bawaan)
|--------------------------------------------------------------------------
*/

// Rute ini untuk pengguna biasa yang sudah login
Route::get('/dashboard', function () {
    // Redirect admin ke admin dashboard
    if (Auth::check() && Auth::user()->role === 'admin') {
        return redirect()->route('admin.dashboard');
    }
    return view('dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});


/*
|--------------------------------------------------------------------------
| Rute Admin (Dilindungi Middleware 'admin')
|--------------------------------------------------------------------------
*/

Route::middleware(['auth', 'verified', 'admin'])->group(function() {
    // Semua rute di sini akan memiliki awalan URL /admin dan nama admin.
    Route::prefix('admin')->name('admin.')->group(function() {
        
        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // Rute Export harus di atas resource agar tidak tertimpa
        Route::get('/products/export', [ProductController::class, 'export'])->name('products.export');
        Route::get('/orders/export', [OrderController::class, 'export'])->name('orders.export');

        // Rute Resource untuk CRUD
        Route::resource('/categories', CategoryController::class);
        Route::resource('/products', ProductController::class);
        Route::resource('/users', UserController::class);
        Route::delete('/product-images/{image}', [ProductController::class, 'destroyImage'])->name('products.images.destroy');
        
        // Rute yang tidak dibuat oleh resource
        Route::get('/orders', [OrderController::class, 'index'])->name('orders.index');
        Route::get('/orders/{order}', [OrderController::class, 'show'])->name('orders.show');
        Route::put('/orders/{order}', [OrderController::class, 'update'])->name('orders.update');

        Route::get('/reviews', [ReviewController::class, 'index'])->name('reviews.index');
        Route::delete('/reviews/{review}', [ReviewController::class, 'destroy'])->name('reviews.destroy');

        Route::get('/settings', [SettingController::class, 'index'])->name('settings.index');
        Route::post('/settings', [SettingController::class, 'update'])->name('settings.update');
    });
});


require __DIR__.'/auth.php';