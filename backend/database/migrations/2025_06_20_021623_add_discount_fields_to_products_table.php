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
        Schema::table('products', function (Blueprint $table) {
            // Harga setelah diskon. Boleh null jika tidak ada diskon.
            $table->decimal('discount_price', 10, 2)->nullable()->after('price');
            // Persentase diskon, untuk memudahkan tampilan di frontend.
            $table->integer('discount_percent')->nullable()->after('discount_price');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['discount_price', 'discount_percent']);
        });
    }
};
