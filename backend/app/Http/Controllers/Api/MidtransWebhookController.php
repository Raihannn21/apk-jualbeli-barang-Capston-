<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Setting;
use Illuminate\Http\Request;
use Midtrans\Config;
use Midtrans\Notification;

class MidtransWebhookController extends Controller
{
    public function handle(Request $request)
    {
        // Konfigurasi Midtrans
        $settings = Setting::where('key', 'midtrans_server_key')->first();
        Config::$serverKey = $settings->value;
        Config::$isProduction = false;

        try {
            // Buat instance dari notifikasi Midtrans
            $notification = new Notification();

            $orderId = explode('-', $notification->order_id)[0];
            $order = Order::find($orderId);

            // Jika pesanan tidak ditemukan, abaikan
            if (!$order) {
                return response()->json(['message' => 'Order not found.'], 404);
            }

            // Periksa status transaksi
            if ($notification->transaction_status == 'settlement') {
                // Jika statusnya 'settlement', artinya pembayaran sukses.
                if ($order->status == 'pending') {
                    $order->update(['status' => 'paid']);
                }
            }
            // Anda bisa tambahkan handling untuk status lain seperti 'expire', 'cancel', 'deny' di sini.

            return response()->json(['message' => 'Notification processed.']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error processing notification: ' . $e->getMessage()], 500);
        }
    }
}
