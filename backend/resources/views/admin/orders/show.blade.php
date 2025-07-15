<x-admin-layout>
    <div class="p-6">
        <!-- Header -->
        <div class="mb-8">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Detail Pesanan #{{ $order->id }}</h1>
                    <p class="mt-2 text-gray-600">{{ $order->created_at->format('d M Y, H:i') }}</p>
                </div>
                <a href="{{ route('admin.orders.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                    Kembali ke Daftar Pesanan
                </a>
            </div>
        </div>

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

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Order Summary & Status Update -->
            <div class="lg:col-span-1 space-y-6">
                <!-- Order Summary -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Ringkasan Pesanan</h3>
                    
                    <div class="space-y-3">
                        <div class="flex justify-between">
                            <span class="text-sm text-gray-600">ID Pesanan:</span>
                            <span class="text-sm font-medium text-gray-900">#{{ $order->id }}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-sm text-gray-600">Tanggal:</span>
                            <span class="text-sm font-medium text-gray-900">{{ $order->created_at->format('d M Y, H:i') }}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-sm text-gray-600">Total:</span>
                            <span class="text-sm font-medium text-gray-900">Rp {{ number_format($order->total_amount, 0, ',', '.') }}</span>
                        </div>
                        <div class="flex justify-between items-center pt-2 border-t border-gray-200">
                            <span class="text-sm text-gray-600">Status:</span>
                            @php
                                $statusColors = [
                                    'pending' => 'bg-yellow-100 text-yellow-800',
                                    'paid' => 'bg-blue-100 text-blue-800',
                                    'shipped' => 'bg-indigo-100 text-indigo-800',
                                    'completed' => 'bg-green-100 text-green-800',
                                    'cancelled' => 'bg-red-100 text-red-800'
                                ];
                            @endphp
                            <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full {{ $statusColors[$order->status] ?? 'bg-gray-100 text-gray-800' }}">
                                {{ ucfirst($order->status) }}
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Status Update Form -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Update Status & Pengiriman</h3>
                    
                    <form action="{{ route('admin.orders.update', $order) }}" method="POST" class="space-y-4">
                        @csrf
                        @method('PUT')

                        <div>
                            <label for="status" class="block text-sm font-medium text-gray-700 mb-2">Status Pesanan</label>
                            <select name="status" id="status" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }}>Pending</option>
                                <option value="paid" {{ $order->status == 'paid' ? 'selected' : '' }}>Paid (Dibayar)</option>
                                <option value="shipped" {{ $order->status == 'shipped' ? 'selected' : '' }}>Shipped (Dikirim)</option>
                                <option value="completed" {{ $order->status == 'completed' ? 'selected' : '' }}>Completed (Selesai)</option>
                                <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled (Dibatalkan)</option>
                            </select>
                        </div>

                        <div>
                            <label for="courier_code" class="block text-sm font-medium text-gray-700 mb-2">Kode Kurir</label>
                            <input type="text" name="courier_code" id="courier_code" 
                                   value="{{ old('courier_code', $order->courier_code) }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="jne, tiki, pos">
                        </div>

                        <div>
                            <label for="waybill_number" class="block text-sm font-medium text-gray-700 mb-2">Nomor Resi</label>
                            <input type="text" name="waybill_number" id="waybill_number" 
                                   value="{{ old('waybill_number', $order->waybill_number) }}" 
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                   placeholder="Masukkan nomor resi">
                            <p class="text-xs text-gray-500 mt-1">Wajib diisi jika status diubah menjadi 'Shipped'</p>
                        </div>

                        <button type="submit" class="w-full inline-flex justify-center items-center px-4 py-2 bg-blue-600 border border-transparent rounded-lg font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
                            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path>
                            </svg>
                            Update Pesanan
                        </button>
                    </form>
                </div>

                <!-- Payment Proof -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Bukti Pembayaran</h3>
                    
                    @if ($order->payment_proof)
                        <div class="text-center">
                            <a href="{{ asset('uploads/' . $order->payment_proof) }}" target="_blank" class="block">
                                <img src="{{ asset('uploads/' . $order->payment_proof) }}" 
                                     alt="Bukti Pembayaran" 
                                     class="w-full max-w-xs mx-auto rounded-lg border border-gray-200 hover:shadow-md transition-shadow">
                            </a>
                            <p class="text-xs text-gray-500 mt-2">Klik untuk memperbesar</p>
                        </div>
                    @else
                        <div class="text-center py-8">
                            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <p class="text-sm text-gray-500 mt-2">Belum ada bukti pembayaran</p>
                        </div>
                    @endif
                </div>
            </div>

            <!-- Customer & Products Info -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Customer & Shipping Info -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-6">Detail Pelanggan & Pengiriman</h3>
                    
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Customer Info -->
                        <div>
                            <h4 class="text-sm font-medium text-gray-900 mb-3">Informasi Pelanggan</h4>
                            <div class="space-y-2">
                                <div class="flex items-center">
                                    <svg class="w-4 h-4 text-gray-400 mr-2" fill="currentColor" viewBox="0 0 20 20">
                                        <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path>
                                    </svg>
                                    <span class="text-sm text-gray-900">{{ $order->user->name }}</span>
                                </div>
                                <div class="flex items-center">
                                    <svg class="w-4 h-4 text-gray-400 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path>
                                    </svg>
                                    <span class="text-sm text-gray-900">{{ $order->user->email }}</span>
                                </div>
                            </div>
                        </div>

                        <!-- Shipping Info -->
                        <div>
                            <h4 class="text-sm font-medium text-gray-900 mb-3">Informasi Pengiriman</h4>
                            @if($order->address)
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-sm font-medium text-gray-900">{{ $order->address->recipient_name }}</p>
                                    <p class="text-sm text-gray-600">{{ $order->address->phone_number }}</p>
                                    <p class="text-sm text-gray-600 mt-1">{{ $order->address->address }}</p>
                                    <p class="text-sm text-gray-600">{{ $order->address->city }}, {{ $order->address->province }} {{ $order->address->postal_code }}</p>
                                </div>
                                <div class="mt-3 space-y-1">
                                    <div class="flex justify-between">
                                        <span class="text-sm text-gray-600">Kurir:</span>
                                        <span class="text-sm font-medium text-gray-900">{{ $order->shipping_courier ?? 'N/A' }}</span>
                                    </div>
                                    <div class="flex justify-between">
                                        <span class="text-sm text-gray-600">Ongkos Kirim:</span>
                                        <span class="text-sm font-medium text-gray-900">Rp {{ number_format($order->shipping_cost ?? 0, 0, ',', '.') }}</span>
                                    </div>
                                </div>
                            @else
                                <p class="text-sm text-gray-500">Alamat tidak tersedia</p>
                            @endif
                        </div>
                    </div>
                </div>

                <!-- Ordered Products -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-6">Produk yang Dipesan</h3>
                    
                    <div class="space-y-4">
                        @foreach($order->items as $item)
                            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                                <div class="flex items-center space-x-4">
                                    <div class="flex-shrink-0 w-12 h-12 bg-gray-200 rounded-lg flex items-center justify-center">
                                        <svg class="w-6 h-6 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-gray-900">{{ $item->product->name }}</p>
                                        <p class="text-sm text-gray-600">Kuantitas: {{ $item->quantity }}</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="text-sm font-medium text-gray-900">Rp {{ number_format($item->price, 0, ',', '.') }}</p>
                                    <p class="text-xs text-gray-500">per item</p>
                                </div>
                            </div>
                        @endforeach
                    </div>

                    <!-- Order Total -->
                    <div class="mt-6 pt-4 border-t border-gray-200">
                        <div class="flex justify-between items-center">
                            <span class="text-base font-medium text-gray-900">Total Pesanan:</span>
                            <span class="text-lg font-bold text-gray-900">Rp {{ number_format($order->total_amount, 0, ',', '.') }}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-admin-layout>