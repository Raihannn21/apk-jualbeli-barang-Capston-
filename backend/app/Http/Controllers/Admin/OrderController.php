<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order; // <-- Tambahkan import
use Illuminate\Http\Request;
use App\Exports\OrdersExport; // <-- Import
use Maatwebsite\Excel\Facades\Excel; // <-- Import
use Illuminate\Support\Carbon;

class OrderController extends Controller
{
    public function index(Request $request)
    {
        // Logika untuk filter cepat
        $period = $request->input('period');
        $startDate = $request->input('start_date') ? Carbon::parse($request->input('start_date')) : null;
        $endDate = $request->input('end_date') ? Carbon::parse($request->input('end_date')) : null;

        if ($period == 'today') {
            $startDate = Carbon::today();
            $endDate = Carbon::now();
        } elseif ($period == 'this_month') {
            $startDate = Carbon::now()->startOfMonth();
            $endDate = Carbon::now()->endOfMonth();
        } elseif ($period == 'this_year') {
            $startDate = Carbon::now()->startOfYear();
            $endDate = Carbon::now()->endOfYear();
        }

        $query = Order::with('user:id,name')
            ->when($request->input('status'), function ($query, $status) {
                return $query->where('status', $status);
            })
            ->when($startDate && $endDate, function ($query) use ($startDate, $endDate) {
                return $query->whereBetween('created_at', [$startDate, $endDate]);
            });

        $orders = $query->latest()->paginate(15);
        return view('admin.orders.index', compact('orders'));
    }

    public function export(Request $request)
    {
        // Ambil semua filter dari request
        $filters = $request->all();
        return Excel::download(new OrdersExport($filters), 'laporan-pesanan.xlsx');
    }


    public function show(Order $order)
    {
        // Eager load semua relasi yang kita butuhkan untuk ditampilkan di view
        $order->load(['user', 'address', 'items.product']);

        return view('admin.orders.show', compact('order'));
    }
    public function update(Request $request, Order $order)
    {
        // Validasi input dengan perbaikan
        $validated = $request->validate([
            'status' => 'required|in:pending,paid,shipped,completed,cancelled',
            // 'courier_code' => 'required_if:status,shipped|string|max:50',
            // 'waybill_number' => 'required_if:status,shipped|string|max:255',
        ]);

        $order->update($validated);

        return redirect()->route('admin.orders.show', $order)->with('success', 'Status pesanan & No. Resi berhasil diperbarui!');
    }
}