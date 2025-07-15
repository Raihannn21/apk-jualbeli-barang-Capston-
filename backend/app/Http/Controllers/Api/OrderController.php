<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use App\Models\UserAddress;
use Illuminate\Support\Facades\Http;
use App\Models\Setting;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        $orders = $request->user()->orders()->latest()->paginate(10);

        return response()->json([
            'success' => true,
            'data' => $orders,
        ]);
    }

    public function show(Request $request, Order $order)
    {
        if ($request->user()->id !== $order->user_id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $order->load('items.product');

        $order->items->transform(function ($item) {
            if ($item->product) {
                $item->product->image_url = asset('uploads/' . $item->product->image);
            }
            return $item;
        });

        return response()->json([
            'success' => true,
            'data' => $order,
        ]);
    }

    /**
     * Membuat pesanan baru dari keranjang belanja user.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_address_id' => 'required|exists:user_addresses,id',
            'shipping_cost' => 'required|numeric',
            'shipping_courier' => 'required|string',
            'cart_item_ids' => 'required|array',
            'cart_item_ids.*' => 'required|integer|exists:cart_items,id'
        ]);

        $user = $request->user();

        $address = $user->addresses()->find($validated['user_address_id']);
        if (!$address) {
            return response()->json(['message' => 'Alamat tidak valid.'], 403);
        }

        $cartItems = $user->cartItems()->with('product')->whereIn('id', $validated['cart_item_ids'])->get();

        if ($cartItems->isEmpty()) {
            return response()->json(['message' => 'Item keranjang yang dipilih tidak ditemukan.'], 400);
        }

        // --- KALKULASI FINAL SEBELUM DISIMPAN ---
        $originalSubtotal = 0;
        $finalSubtotal = 0;
        foreach ($cartItems as $item) {
            $originalPrice = $item->product->price;
            $finalPrice = $item->product->discount_price ?? $originalPrice;

            $originalSubtotal += $originalPrice * $item->quantity;
            $finalSubtotal += $finalPrice * $item->quantity;
        }
        $totalDiscount = $originalSubtotal - $finalSubtotal;
        $shippingCost = $validated['shipping_cost'];
        $totalAmount = $finalSubtotal + $shippingCost;

        $order = DB::transaction(function () use ($user, $cartItems, $validated, $originalSubtotal, $totalDiscount, $shippingCost, $totalAmount) {
            // Simpan pesanan baru dengan SEMUA rincian harga
            $order = Order::create([
                'user_id' => $user->id,
                'user_address_id' => $validated['user_address_id'],
                'total_amount' => $totalAmount,
                'subtotal' => $originalSubtotal,
                'discount_amount' => $totalDiscount,
                'shipping_cost' => $shippingCost,
                'shipping_courier' => $validated['shipping_courier'],
                'status' => 'pending',
            ]);

            foreach ($cartItems as $item) {
                $order->items()->create([
                    'product_id' => $item->product_id,
                    'quantity' => $item->quantity,
                    'price' => $item->product->discount_price ?? $item->product->price,
                ]);
                $item->product->decrement('stock', $item->quantity);
            }

            $user->cartItems()->whereIn('id', $validated['cart_item_ids'])->delete();

            return $order;
        });

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibuat.',
            'data' => $order->load('items.product', 'address'),
        ], 201);
    }
    public function confirmDelivery(Request $request, Order $order)
    {
        // 1. Otorisasi: Pastikan user yang membuat request adalah pemilik pesanan
        if ($request->user()->id !== $order->user_id) {
            return response()->json(['message' => 'Akses ditolak. Anda bukan pemilik pesanan ini.'], 403);
        }

        // 2. Validasi Status: Pastikan pesanan memang sedang dalam status 'shipped'
        if ($order->status !== 'shipped') {
            return response()->json([
                'message' => 'Pesanan ini tidak bisa dikonfirmasi karena statusnya bukan \'shipped\'.'
            ], 422); // 422 Unprocessable Entity
        }

        // 3. Jika semua aman, update status pesanan
        $order->update(['status' => 'completed']);

        // 4. Kembalikan Response Sukses
        return response()->json([
            'success' => true,
            'message' => 'Konfirmasi pesanan berhasil. Terima kasih telah berbelanja!',
            'data' => $order,
        ]);
    }
    public function cancel(Request $request, Order $order)
    {
        // 1. Otorisasi: Pastikan user adalah pemilik pesanan
        if ($request->user()->id !== $order->user_id) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        // 2. Validasi Status: Hanya boleh batal jika status 'pending'
        if ($order->status !== 'pending') {
            return response()->json(['message' => 'Pesanan ini tidak dapat dibatalkan.'], 422);
        }

        // Gunakan transaksi untuk memastikan semua proses berhasil atau semua gagal
        DB::transaction(function () use ($order) {
            // Loop setiap item di dalam pesanan untuk mengembalikan stok
            foreach ($order->items as $item) {
                // Tambahkan kembali stok produk
                $item->product()->increment('stock', $item->quantity);
            }

            // Update status pesanan menjadi 'cancelled'
            $order->update(['status' => 'cancelled']);
        });

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil dibatalkan.',
            'data' => $order->fresh(), // Ambil data order terbaru
        ]);
    }
    public function uploadPaymentProof(Request $request, Order $order)
    {
        // 1. Otorisasi: Pastikan user adalah pemilik pesanan
        if ($request->user()->id !== $order->user_id) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        // 2. Validasi Status: Hanya boleh upload jika status 'pending'
        if ($order->status !== 'pending') {
            return response()->json(['message' => 'Konfirmasi pembayaran untuk pesanan ini sudah tidak bisa dilakukan.'], 422);
        }

        // 3. Validasi File
        $request->validate([
            'proof' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048', // File wajib ada, maks 2MB
        ]);

        // 4. Simpan File Gambar
        if ($request->hasFile('proof')) {
            // Hapus bukti pembayaran lama jika ada
            if ($order->payment_proof) {
                Storage::disk('uploads')->delete($order->payment_proof);
            }

            // Simpan file baru ke public/uploads/proofs
            $path = $request->file('proof')->store('proofs', 'uploads');

            // 5. Update Database
            $order->update([
                'payment_proof' => $path,
                'payment_method' => 'Manual Bank Transfer',
            ]);
        }

        // 6. Kembalikan Response Sukses
        return response()->json([
            'success' => true,
            'message' => 'Bukti pembayaran berhasil di-upload. Pesanan akan segera kami proses.',
            'data' => $order->fresh(), // Ambil data order terbaru
        ]);
    }
    // public function track(Request $request, Order $order)
    // {
    //     // 1. Otorisasi
    //     if ($request->user()->id !== $order->user_id) {
    //         return response()->json(['success' => false, 'message' => 'Akses ditolak.'], 403);
    //     }

    //     // 2. Validasi
    //     if (empty($order->waybill_number) || empty($order->courier_code)) {
    //         return response()->json(['success' => false, 'message' => 'Nomor resi untuk pesanan ini tidak tersedia.'], 404);
    //     }

    //     // 3. Ambil API Key
    //     $apiKeySetting = Setting::where('key', 'rajaongkir_api_key')->first();
    //     if (!$apiKeySetting || !$apiKeySetting->value) {
    //         return response()->json(['success' => false, 'message' => 'API Key RajaOngkir belum diatur.'], 500);
    //     }
    //     $apiKey = $apiKeySetting->value;

    //     // 4. Panggil API RajaOngkir dengan parameter yang benar
    //     try {
    //         $response = Http::asForm()->withHeaders([
    //             'key' => $apiKey
    //         ])->post('https://rajaongkir.komerce.id/api/v1/track/waybill', [
    //             'Awb' => $order->waybill_number, // <-- MENGGUNAKAN 'Awb'
    //             'courier' => $order->courier_code,
    //         ]);

    //         $rajaongkirData = $response->json();

    //         // Cek jika RajaOngkir sendiri memberikan error
    //         if ($rajaongkirData['meta']['code'] != 200) {
    //             // Lempar exception dengan pesan error dari RajaOngkir
    //             throw new \Exception($rajaongkirData['meta']['message']);
    //         }

    //         // Bungkus jawaban sukses dalam format standar kita
    //         return response()->json([
    //             'success' => true,
    //             'data'    => $rajaongkirData['data']
    //         ]);
    //     } catch (\Exception $e) {
    //         // Tangkap semua error dan kembalikan dalam format standar kita
    //         return response()->json([
    //             'success' => false,
    //             'message' => 'Gagal melacak pengiriman: ' . $e->getMessage()
    //         ], 500);
    //     }
    // }
}
