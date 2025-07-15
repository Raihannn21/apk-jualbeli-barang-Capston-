<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        // --- Data Statistik KEMBALI menampilkan data TOTAL sepanjang masa ---
        $userCount = User::where('role', 'user')->count();
        $productCount = Product::count();
        $orderCount = Order::count();
        $totalRevenue = Order::where('status', 'completed')->sum('total_amount');
        $latestOrders = Order::with('user')->latest()->take(5)->get();

        // --- Filter tanggal SEKARANG HANYA untuk data grafik ---
        $startDate = $request->input('start_date') ? Carbon::parse($request->input('start_date')) : Carbon::now()->subDays(30);
        $endDate = $request->input('end_date') ? Carbon::parse($request->input('end_date')) : Carbon::now();

        $ordersByDay = Order::where('status', 'completed')
            ->whereBetween('created_at', [$startDate, $endDate])
            ->get()
            ->groupBy(function ($date) {
                return Carbon::parse($date->created_at)->format('d M Y');
            })
            ->map(function ($group) {
                return $group->sum('total_amount');
            });

        $chartLabels = $ordersByDay->keys();
        $chartData = $ordersByDay->values();

        // Kirim semua data ke view
        return view('admin.dashboard', compact(
            'userCount', 'productCount', 'orderCount', 'totalRevenue', 'latestOrders',
            'chartLabels', 'chartData', 
            'startDate', 'endDate'
        ));
    }

}