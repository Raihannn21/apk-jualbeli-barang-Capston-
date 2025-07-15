<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id(); // Kolom `id` (Primary Key, BIGINT, AUTO_INCREMENT)
            $table->string('name');
            $table->text('description');
            $table->decimal('price', 10, 2); // 10 digit total, 2 di belakang koma
            $table->integer('stock');
            $table->string('image'); // Untuk menyimpan path file gambar
            $table->timestamps(); // Kolom `created_at` dan `updated_at`
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
