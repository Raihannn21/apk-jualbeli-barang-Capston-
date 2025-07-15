<x-admin-layout>
    <x-slot name="header">
        <div>
            <h1 class="text-3xl font-bold text-gray-900">Pengaturan Aplikasi</h1>
            <p class="mt-2 text-gray-600">Konfigurasi pengaturan sistem untuk integrasi layanan eksternal</p>
        </div>
    </x-slot>

    <div>
        <!-- Success Message -->
        @if (session('success'))
            <div class="mb-6 bg-green-50 border border-green-200 rounded-lg p-4">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-green-400" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                        </svg>
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium text-green-800">{{ session('success') }}</p>
                    </div>
                </div>
            </div>
        @endif

        <!-- Settings Form -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
            <form action="{{ route('admin.settings.update') }}" method="POST" class="p-6 space-y-8">
                @csrf
                
                <!-- RajaOngkir Settings -->
                <div>
                    <div class="flex items-center mb-6">
                        <div class="flex-shrink-0">
                            <div class="p-3 bg-blue-100 rounded-lg">
                                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                                </svg>
                            </div>
                        </div>
                        <div class="ml-4">
                            <h3 class="text-lg font-medium text-gray-900">Pengaturan RajaOngkir</h3>
                            <p class="text-sm text-gray-600">Konfigurasi layanan pengiriman RajaOngkir API</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="rajaongkir_api_key" class="block text-sm font-medium text-gray-700 mb-2">API Key RajaOngkir</label>
                            <input type="text" name="rajaongkir_api_key" id="rajaongkir_api_key" 
                                   value="{{ $settings['rajaongkir_api_key'] ?? '' }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Masukkan API Key RajaOngkir">
                        </div>

                        <div>
                            <label for="rajaongkir_origin_city_id" class="block text-sm font-medium text-gray-700 mb-2">ID Kota Asal Pengiriman</label>
                            <input type="number" name="rajaongkir_origin_city_id" id="rajaongkir_origin_city_id" 
                                   value="{{ $settings['rajaongkir_origin_city_id'] ?? '' }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="357">
                            <p class="text-xs text-gray-500 mt-1">Cari ID Kota Anda di dokumentasi RajaOngkir. Contoh: Padang = 357</p>
                        </div>

                        <div class="md:col-span-2">
                            <label for="rajaongkir_courier" class="block text-sm font-medium text-gray-700 mb-2">Kurir yang Aktif</label>
                            <input type="text" name="rajaongkir_courier" id="rajaongkir_courier" 
                                   value="{{ $settings['rajaongkir_courier'] ?? 'jne:pos:tiki' }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="jne:tiki:pos">
                            <p class="text-xs text-gray-500 mt-1">Gunakan format kode kurir yang dipisah titik dua. Contoh: jne:tiki:pos</p>
                        </div>
                    </div>
                </div>

                <!-- Midtrans Settings -->
                <div class="border-t border-gray-200 pt-8">
                    <div class="flex items-center mb-6">
                        <div class="flex-shrink-0">
                            <div class="p-3 bg-green-100 rounded-lg">
                                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                                </svg>
                            </div>
                        </div>
                        <div class="ml-4">
                            <h3 class="text-lg font-medium text-gray-900">Pengaturan Midtrans</h3>
                            <p class="text-sm text-gray-600">Konfigurasi gateway pembayaran Midtrans</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="midtrans_server_key" class="block text-sm font-medium text-gray-700 mb-2">Server Key Midtrans</label>
                            <input type="text" name="midtrans_server_key" id="midtrans_server_key" 
                                   value="{{ $settings['midtrans_server_key'] ?? '' }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="SB-Mid-server-xxxxx atau Mid-server-xxxxx">
                        </div>

                        <div>
                            <label for="midtrans_is_production" class="block text-sm font-medium text-gray-700 mb-2">Mode Environment</label>
                            <select name="midtrans_is_production" id="midtrans_is_production" 
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                <option value="false" {{ ($settings['midtrans_is_production'] ?? 'false') == 'false' ? 'selected' : '' }}>
                                    Sandbox (Testing)
                                </option>
                                <option value="true" {{ ($settings['midtrans_is_production'] ?? 'false') == 'true' ? 'selected' : '' }}>
                                    Production (Live)
                                </option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Configuration Status -->
                <div class="border-t border-gray-200 pt-8">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Status Konfigurasi</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                            <div class="flex-shrink-0">
                                @if(!empty($settings['rajaongkir_api_key']) && !empty($settings['rajaongkir_origin_city_id']))
                                    <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                    </svg>
                                @else
                                    <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                                    </svg>
                                @endif
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-gray-900">RajaOngkir API</p>
                                <p class="text-xs text-gray-500">
                                    @if(!empty($settings['rajaongkir_api_key']) && !empty($settings['rajaongkir_origin_city_id']))
                                        Konfigurasi lengkap
                                    @else
                                        Perlu konfigurasi
                                    @endif
                                </p>
                            </div>
                        </div>

                        <div class="flex items-center p-4 bg-gray-50 rounded-lg">
                            <div class="flex-shrink-0">
                                @if(!empty($settings['midtrans_server_key']))
                                    <svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                                    </svg>
                                @else
                                    <svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                                    </svg>
                                @endif
                            </div>
                            <div class="ml-3">
                                <p class="text-sm font-medium text-gray-900">Midtrans Payment</p>
                                <p class="text-xs text-gray-500">
                                    @if(!empty($settings['midtrans_server_key']))
                                        Konfigurasi lengkap
                                    @else
                                        Perlu konfigurasi
                                    @endif
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="flex justify-end pt-6 border-t border-gray-200">
                    <button type="submit" class="inline-flex items-center px-6 py-3 bg-blue-600 border border-transparent rounded-lg font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
                        <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-3m-1 4l-3-3m0 0l-3 3m3-3v12"></path>
                        </svg>
                        Simpan Pengaturan
                    </button>
                </div>
            </form>
        </div>
    </div>
</x-admin-layout>