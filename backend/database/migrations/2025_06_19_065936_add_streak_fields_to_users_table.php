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
        Schema::table('users', function (Blueprint $table) {
            // Menyimpan jumlah hari beruntun, defaultnya 0
            $table->integer('login_streak')->default(0)->after('password');
            // Menyimpan kapan terakhir kali login
            $table->timestamp('last_login_at')->nullable()->after('login_streak');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['login_streak', 'last_login_at']);
        });
    }
};
