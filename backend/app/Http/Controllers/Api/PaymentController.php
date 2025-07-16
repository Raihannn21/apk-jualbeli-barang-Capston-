<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Setting;
use Illuminate\Http\Request;
use Midtrans\Config;
use Midtrans\Snap;

class PaymentController extends Controller
{
    public function createTransaction(Request $request, Order $order)
    {
        if ($request->user()->id !== $order->user_id) {
            return response()->json(['message' => 'Akses ditolak.'], 403);
        }

        $settings = Setting::whereIn('key', ['midtrans_server_key', 'midtrans_is_production'])->pluck('value', 'key');
        if (empty($settings['midtrans_server_key'])) {
            return response()->json(['message' => 'Kunci Server Midtrans belum diatur.'], 500);
        }

        Config::$serverKey = $settings['midtrans_server_key'];
        Config::$isProduction = ($settings['midtrans_is_production'] ?? 'false') === 'true';
        Config::$isSanitized = true;
        Config::$is3ds = true;

        $transaction_details = [
            'order_id' => $order->id . '-' . time(),
            'gross_amount' => (int) $order->total_amount,
        ];

        $customer_details = [
            'first_name' => $order->user->name,
            'email' => $order->user->email,
            'phone' => $order->address->phone_number,
        ];

        $params = [
            'transaction_details' => $transaction_details,
            'customer_details' => $customer_details,
        ];

        try {
            $paymentUrl = Snap::createTransaction($params)->redirect_url;
            $snapToken = Snap::getSnapToken($params);

            $order->payment_token = $snapToken;
            $order->payment_url = $paymentUrl;
            $order->save();

            return response()->json([
                'success' => true,
                'payment_token' => $snapToken,
                'payment_url' => $paymentUrl
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => $e->getMessage()], 500);
        }
    }
}
