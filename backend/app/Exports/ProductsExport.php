<?php

namespace App\Exports;

use App\Models\Product;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;

class ProductsExport implements FromCollection, WithHeadings, WithMapping
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        return Product::with('category')->get();
    }

    /**
     * Menentukan header untuk setiap kolom di file Excel.
     */
    public function headings(): array
    {
        return [
            'ID',
            'Nama Produk',
            'Kategori',
            'Harga',
            'Stok',
            'Deskripsi',
            'Tanggal Dibuat',
        ];
    }

    /**
     * Memetakan data dari setiap produk ke kolom yang sesuai.
     */
    public function map($product): array
    {
        return [
            $product->id,
            $product->name,
            $product->category->name ?? 'N/A', // Ambil nama kategori dari relasi
            $product->price,
            $product->stock,
            $product->description,
            $product->created_at->format('d-m-Y H:i:s'),
        ];
    }
}