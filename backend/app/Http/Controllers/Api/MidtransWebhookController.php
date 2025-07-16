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

            if (!$order) {
                return response()->json(['message' => 'Order not found.'], 404);
            }
            if ($notification->transaction_status == 'settlement') {
                if ($order->status == 'pending') {
                    $order->update(['status' => 'paid']);
                }
            }

            return response()->json(['message' => 'Notification processed.']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Error processing notification: ' . $e->getMessage()], 500);
        }
    }
}
