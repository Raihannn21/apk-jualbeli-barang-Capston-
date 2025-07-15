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
        Schema::table('orders', function (Blueprint $table) {
            // Kode kurir dari RajaOngkir, cth: 'jne', 'tiki'
            $table->string('courier_code')->nullable()->after('shipping_courier');
            // Nomor resi dari kurir
            $table->string('waybill_number')->nullable()->after('courier_code');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('orders', function (Blueprint $table) {
            $table->dropColumn(['courier_code', 'waybill_number']);
        });
    }
};
