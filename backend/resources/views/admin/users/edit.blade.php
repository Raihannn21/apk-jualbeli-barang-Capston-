<x-admin-layout>
    <div class="p-6">
        <!-- Header -->
        <div class="mb-8">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">Edit Role Pengguna</h1>
                    <p class="mt-2 text-gray-600">Ubah hak akses pengguna dalam sistem</p>
                </div>
                <a href="{{ route('admin.users.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                    </svg>
                    Kembali
                </a>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- User Information -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Informasi Pengguna</h3>
                    
                    <div class="text-center">
                        <div class="w-20 h-20 bg-gray-200 rounded-full flex items-center justify-center mx-auto mb-4">
                            <svg class="w-10 h-10 text-gray-500" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path>
                            </svg>
                        </div>
                        <h4 class="text-lg font-medium text-gray-900">{{ $user->name }}</h4>
                        <p class="text-sm text-gray-600">{{ $user->email }}</p>
                        
                        <div class="mt-4 pt-4 border-t border-gray-200">
                            <div class="text-left space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-500">ID:</span>
                                    <span class="text-sm font-medium text-gray-900">#{{ $user->id }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-500">Bergabung:</span>
                                    <span class="text-sm font-medium text-gray-900">{{ $user->created_at->format('d M Y') }}</span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-500">Role Saat Ini:</span>
                                    <span class="inline-flex px-2 py-1 text-xs font-semibold rounded-full {{ $user->role == 'admin' ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 text-gray-800' }}">
                                        {{ ucfirst($user->role) }}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Edit Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200">
                    <form action="{{ route('admin.users.update', $user) }}" method="POST" class="p-6 space-y-6">
                        @csrf
                        @method('PUT')
                        
                        <!-- Role Selection -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Pengaturan Role</h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 mb-3">Pilih Role Pengguna</label>
                                    <div class="space-y-3">
                                        <div class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                                            <input id="role_user" name="role" type="radio" value="user" 
                                                   {{ $user->role == 'user' ? 'checked' : '' }}
                                                   class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                                            <label for="role_user" class="ml-3 flex-1 cursor-pointer">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0">
                                                        <div class="w-8 h-8 bg-gray-100 rounded-full flex items-center justify-center">
                                                            <svg class="w-4 h-4 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                                                                <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"></path>
                                                            </svg>
                                                        </div>
                                                    </div>
                                                    <div class="ml-3">
                                                        <p class="text-sm font-medium text-gray-900">User</p>
                                                        <p class="text-xs text-gray-500">Akses standar untuk pelanggan. Dapat berbelanja dan melihat pesanan.</p>
                                                    </div>
                                                </div>
                                            </label>
                                        </div>

                                        <div class="flex items-center p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors">
                                            <input id="role_admin" name="role" type="radio" value="admin" 
                                                   {{ $user->role == 'admin' ? 'checked' : '' }}
                                                   class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300">
                                            <label for="role_admin" class="ml-3 flex-1 cursor-pointer">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0">
                                                        <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                                                            <svg class="w-4 h-4 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                                                                <path fill-rule="evenodd" d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" clip-rule="evenodd"></path>
                                                            </svg>
                                                        </div>
                                                    </div>
                                                    <div class="ml-3">
                                                        <p class="text-sm font-medium text-gray-900">Admin</p>
                                                        <p class="text-xs text-gray-500">Akses penuh ke dashboard admin. Dapat mengelola produk, pesanan, dan pengguna.</p>
                                                    </div>
                                                </div>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Warning -->
                        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4">
                            <div class="flex">
                                <div class="flex-shrink-0">
                                    <svg class="h-5 w-5 text-yellow-400" viewBox="0 0 20 20" fill="currentColor">
                                        <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                                    </svg>
                                </div>
                                <div class="ml-3">
                                    <h3 class="text-sm font-medium text-yellow-800">Perhatian</h3>
                                    <div class="mt-2 text-sm text-yellow-700">
                                        <p>Mengubah role ke Admin akan memberikan akses penuh ke dashboard admin. Pastikan hanya memberikan akses ini kepada orang yang tepercaya.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Submit Button -->
                        <div class="flex justify-end pt-6 border-t border-gray-200">
                            <button type="submit" class="inline-flex items-center px-6 py-3 bg-blue-600 border border-transparent rounded-lg font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors">
                                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path>
                                </svg>
                                Update Role
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</x-admin-layout>