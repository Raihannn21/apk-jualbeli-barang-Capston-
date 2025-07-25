<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class ShippingController extends Controller
{
    public function checkCost(Request $request)
    {
        $validated = $request->validate([
            'destination_city_id' => 'required|integer',
            'cart_item_ids' => 'required|array',
            'cart_item_ids.*' => 'required|integer|exists:cart_items,id'
        ]);

        $settings = Setting::whereIn('key', [
            'rajaongkir_api_key',
            'rajaongkir_origin_city_id',
            'rajaongkir_courier'
        ])->pluck('value', 'key');

        if (empty($settings['rajaongkir_api_key']) || empty($settings['rajaongkir_origin_city_id']) || empty($settings['rajaongkir_courier'])) {
            return response()->json(['message' => 'Pengaturan pengiriman belum lengkap.'], 500);
        }

        $cartItems = $request->user()->cartItems()->with('product')->whereIn('id', $validated['cart_item_ids'])->get();
        $totalWeight = $cartItems->sum(function ($item) {
            return $item->quantity * $item->product->weight;
        });

        try {
            $response = Http::asForm()->withHeaders([
                'key' => $settings['rajaongkir_api_key']
            ])->post('https://rajaongkir.komerce.id/api/v1/calculate/domestic-cost', [
                'origin'        => $settings['rajaongkir_origin_city_id'],
                'destination'   => $validated['destination_city_id'],
                'weight'        => $totalWeight,
                'courier'       => strtolower($settings['rajaongkir_courier'])
            ]);

            if ($response->failed()) {
                return response()->json(['success' => false, 'message' => 'Gagal terhubung ke server RajaOngkir.'], 500);
            }

            $data = $response->json();

            if ($data['meta']['code'] != 200) {
                return response()->json([
                    'success' => false,
                    'message' => 'Gagal mengambil data dari RajaOngkir.',
                    'details' => $data['meta']['message'] ?? 'No details'
                ], 500);
            }

            $shippingOptions = $data['data'];

            return response()->json([
                'success' => true,
                'data' => $shippingOptions
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan internal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
