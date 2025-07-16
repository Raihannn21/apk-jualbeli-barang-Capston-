<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Setting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class LocationController extends Controller
{
    /**
     * Mencari data lokasi (provinsi/kota/kecamatan) dari API RajaOngkir Komerce.
     */
    public function search(Request $request)
    {
        $validated = $request->validate([
            'q' => 'required|string|min:3'
        ]);

        $apiKeySetting = Setting::where('key', 'rajaongkir_api_key')->first();
        if (!$apiKeySetting || !$apiKeySetting->value) {
            return response()->json(['message' => 'API Key RajaOngkir tidak diatur.'], 500);
        }
        $apiKey = $apiKeySetting->value;

        try {
            $response = Http::withHeaders([
                'key' => $apiKey
            ])->get('https://rajaongkir.komerce.id/api/v1/destination/domestic-destination', [
                'search' => $validated['q']
            ]);

            if ($response->failed()) {
                return response()->json(['success' => false, 'message' => 'Gagal terhubung ke server RajaOngkir.'], 500);
            }
            
            return response()->json($response->json());

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan internal.',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}