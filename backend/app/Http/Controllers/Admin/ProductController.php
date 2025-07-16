<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Maatwebsite\Excel\Facades\Excel;
use App\Exports\ProductsExport;
use Illuminate\Support\Facades\DB;
use App\Models\ProductImage;

class ProductController extends Controller
{
    /**
     * Menampilkan halaman daftar produk.
     */
    public function index(Request $request)
    {
        $search = $request->input('search');

        $products = Product::with('category')
            ->when($search, function ($query, $search) {
                return $query->where('name', 'like', '%' . $search . '%');
            })
            ->latest()
            ->paginate(15);

        return view('admin.products.index', compact('products'));
    }

    /**
     * Menampilkan form untuk membuat produk baru.
     */
    public function create()
    {
        $categories = Category::all();
        return view('admin.products.create', compact('categories'));
    }

    /**
     * Menyimpan produk baru ke database.
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'description' => 'required|string',
            'price' => 'required|numeric',
            'discount_percent' => 'nullable|integer|min:1|max:100',
            'stock' => 'required|integer',
            'weight' => 'required|integer|min:1',
            'images' => 'required|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);
        if (!empty($validatedData['discount_percent'])) {
            $originalPrice = $validatedData['price'];
            $discountPercent = $validatedData['discount_percent'];
            // Hitung harga setelah diskon
            $validatedData['discount_price'] = $originalPrice - ($originalPrice * $discountPercent / 100);
        } else {
            $validatedData['discount_price'] = null;
        }
        DB::transaction(function () use ($request, $validatedData) {
            
            $productData = collect($validatedData)->except('images')->toArray();
            $product = Product::create($productData);

            if ($request->hasFile('images')) {
                $isFirstImage = true;
                foreach ($request->file('images') as $imageFile) {
                    $path = $imageFile->store('products', 'uploads');

                    if ($isFirstImage) {
                        $product->update(['image' => $path]);
                        $isFirstImage = false;
                    }

                    $product->images()->create(['image_path' => $path]);
                }
            }
        });

        return redirect()->route('admin.products.index')->with('success', 'Produk baru berhasil ditambahkan dengan galeri gambar!');
    }

    /**
     * Menampilkan form untuk mengedit produk.
     */
    public function edit(Product $product)
    {
        // dd($product);
        $categories = Category::all();
        return view('admin.products.edit', compact('product', 'categories'));
    }

    /**
     * Memperbarui data produk di database.
     */
    public function update(Request $request, Product $product)
    {
        // Validasi data utama
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'category_id' => 'required|exists:categories,id',
            'description' => 'required|string',
            'price' => 'required|numeric',
            'discount_percent' => 'nullable|integer|min:1|max:100',
            'stock' => 'required|integer',
            'weight' => 'required|integer|min:1',
            'images' => 'nullable|array', // Gambar baru tidak wajib
            'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);
        if (!empty($validatedData['discount_percent'])) {
            $originalPrice = $validatedData['price'];
            $discountPercent = $validatedData['discount_percent'];
            $validatedData['discount_price'] = $originalPrice - ($originalPrice * $discountPercent / 100);
        } else {
            $validatedData['discount_price'] = null;
        }

        $product->update(collect($validatedData)->except('images')->toArray());

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $imageFile) {
                $path = $imageFile->store('products', 'uploads');
                $product->images()->create(['image_path' => $path]);
            }
        }

        return redirect()->route('admin.products.index', $product)->with('success', 'Produk berhasil diperbarui!');
    }

    /**
     * Menghapus produk dari database.
     */
    public function destroy(Product $product)
    {
        if ($product->image) {
            // PERBAIKAN DI SINI: Menghapus dari disk 'uploads'
            Storage::disk('uploads')->delete($product->image);
        }
        $product->delete();
        return redirect()->route('admin.products.index')->with('success', 'Produk berhasil dihapus!');
    }
    public function export()
    {
        // Panggil class export kita dan tentukan nama filenya
        return Excel::download(new ProductsExport, 'daftar-produk.xlsx');
    }
    public function destroyImage(ProductImage $image)
    {
        // Hapus file dari storage
        Storage::disk('uploads')->delete($image->image_path);

        // Hapus record dari database
        $image->delete();

        // Kembali ke halaman sebelumnya dengan pesan sukses
        return back()->with('success', 'Gambar berhasil dihapus.');
    }
}