<x-admin-layout>
    <x-slot name="header">
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold text-gray-900">Edit Kategori</h1>
                <p class="mt-2 text-gray-600">{{ $category->name }}</p>
            </div>
            <a href="{{ route('admin.categories.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200">
                <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
                Kembali
            </a>
        </div>
    </x-slot>

    <div>
        <!-- Error Messages -->
        @if ($errors->any())
            <div class="mb-6 bg-red-50 border border-red-200 rounded-lg p-4">
                <div class="flex">
                    <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-red-400" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                        </svg>
                    </div>
                    <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800">Terdapat beberapa error:</h3>
                        <div class="mt-2 text-sm text-red-700">
                            <ul class="list-disc list-inside space-y-1">
                                @foreach ($errors->all() as $error)
                                    <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        @endif

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Current Image -->
            <div class="lg:col-span-1">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h3 class="text-lg font-medium text-gray-900 mb-4">Ikon Saat Ini</h3>
                    
                    @if($category->image)
                        <div class="text-center">
                            @php
                                // Handle different image path formats
                                $imagePath = str_contains($category->image, 'categories/') 
                                    ? 'uploads/' . $category->image 
                                    : 'uploads/categories/' . $category->image;
                            @endphp
                            <img src="{{ asset($imagePath) }}" alt="{{ $category->name }}" 
                                 class="w-32 h-32 object-cover rounded-lg border border-gray-200 mx-auto">
                            <p class="text-sm text-gray-500 mt-2">{{ $category->name }}</p>
                        </div>
                    @else
                        <div class="text-center py-8">
                            <div class="w-32 h-32 bg-gray-100 rounded-lg flex items-center justify-center mx-auto">
                                <svg class="w-12 h-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"></path>
                                </svg>
                            </div>
                            <p class="text-sm text-gray-500 mt-2">Belum ada ikon</p>
                        </div>
                    @endif
                </div>
            </div>

            <!-- Edit Form -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200">
                    <form action="{{ route('admin.categories.update', $category) }}" method="POST" enctype="multipart/form-data" class="p-6 space-y-6">
                        @csrf
                        @method('PUT')
                        
                        <!-- Basic Information -->
                        <div>
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Informasi Kategori</h3>
                            
                            <div class="space-y-4">
                                <div>
                                    <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                                        Nama Kategori <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" name="name" id="name" value="{{ old('name', $category->name) }}" 
                                           class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" 
                                           placeholder="Masukkan nama kategori" required>
                                </div>

                                <div>
                                    <label for="image" class="block text-sm font-medium text-gray-700 mb-2">
                                        Ganti Ikon <span class="text-gray-500">(Opsional)</span>
                                    </label>
                                    <div class="mt-1 flex justify-center px-6 pt-5 pb-6 border-2 border-gray-300 border-dashed rounded-lg hover:border-blue-400 transition-colors">
                                        <div class="space-y-1 text-center">
                                            <svg class="mx-auto h-12 w-12 text-gray-400" stroke="currentColor" fill="none" viewBox="0 0 48 48">
                                                <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
                                            </svg>
                                            <div class="flex text-sm text-gray-600">
                                                <label for="image" class="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500">
                                                    <span>Upload ikon baru</span>
                                                    <input id="image" name="image" type="file" class="sr-only" accept="image/*" onchange="previewNewCategoryIcon(this)">
                                                </label>
                                                </label>
                                                <p class="pl-1">atau drag and drop</p>
                                            </div>
                                            <p class="text-xs text-gray-500">PNG, JPG, JPEG up to 5MB</p>
                                            @if($category->image)
                                                <p class="text-xs text-blue-600 mt-2">Biarkan kosong untuk tetap menggunakan ikon saat ini</p>
                                            @endif
                                        </div>
                                    </div>
                                    
                                    <!-- Preview Area for New Icon -->
                                    <div id="new-icon-preview" class="mt-4 hidden">
                                        <div class="flex items-center space-x-3 p-3 bg-gray-50 rounded-lg border border-gray-200">
                                            <div class="w-12 h-12 rounded-lg overflow-hidden bg-white border border-gray-200">
                                                <img id="preview-new-icon" src="" alt="Preview New Icon" class="w-full h-full object-cover">
                                            </div>
                                            <div>
                                                <p class="text-sm font-medium text-gray-900">Preview Ikon Baru</p>
                                                <p class="text-xs text-gray-500">Ikon baru akan tampil seperti ini</p>
                                            </div>
                                            <button type="button" onclick="clearNewIconPreview()" class="ml-auto text-red-500 hover:text-red-700">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                                </svg>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Category Preview -->
                        <div class="border-t border-gray-200 pt-6">
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Preview Kategori</h3>
                            <div class="bg-gray-50 rounded-lg p-4">
                                <div class="flex items-center space-x-3">
                                    <div class="flex-shrink-0 w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                        <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"></path>
                                        </svg>
                                    </div>
                                    <div>
                                        <p class="text-sm font-medium text-gray-900" id="preview-name">{{ $category->name }}</p>
                                        <p class="text-xs text-gray-500">Kategori produk</p>
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
                                Update Kategori
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript for live preview -->
    <script>
        document.getElementById('name').addEventListener('input', function(e) {
            const previewName = document.getElementById('preview-name');
            previewName.textContent = e.target.value || '{{ $category->name }}';
        });

        function previewNewCategoryIcon(input) {
            const previewContainer = document.getElementById('new-icon-preview');
            const previewIcon = document.getElementById('preview-new-icon');
            
            if (input.files && input.files[0]) {
                const file = input.files[0];
                
                if (file.type.startsWith('image/')) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        previewIcon.src = e.target.result;
                        previewContainer.classList.remove('hidden');
                    };
                    reader.readAsDataURL(file);
                } else {
                    alert('Please select a valid image file');
                    input.value = '';
                }
            }
        }

        function clearNewIconPreview() {
            const previewContainer = document.getElementById('new-icon-preview');
            const previewIcon = document.getElementById('preview-new-icon');
            const fileInput = document.getElementById('image');
            
            previewIcon.src = '';
            previewContainer.classList.add('hidden');
            fileInput.value = '';
        }
    </script>
</x-admin-layout>