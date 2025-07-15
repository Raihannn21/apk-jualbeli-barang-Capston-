<?php

namespace App\Exports;

use App\Models\Order;
use Maatwebsite\Excel\Concerns\FromQuery;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;
use Maatwebsite\Excel\Concerns\WithEvents;
use Maatwebsite\Excel\Events\AfterSheet;
use Illuminate\Support\Carbon;

class OrdersExport implements FromQuery, WithHeadings, WithMapping, WithEvents
{
    protected $filters;

    public function __construct(array $filters)
    {
        $this->filters = $filters;
    }

    public function query()
    {
        $query = Order::with('user:id,name')->latest();

        if (!empty($this->filters['status'])) {
            $query->where('status', $this->filters['status']);
        }

        if (!empty($this->filters['start_date']) && !empty($this->filters['end_date'])) {
            $startDate = Carbon::parse($this->filters['start_date']);
            $endDate = Carbon::parse($this->filters['end_date']);
            $query->whereBetween('created_at', [$startDate, $endDate]);
        }

        return $query;
    }

    public function headings(): array
    {
        return [
            'Order ID', 'Nama Pembeli', 'Email Pembeli', 'Status', 'Ongkos Kirim', 'Total Tagihan', 'Tanggal Pesanan'
        ];
    }

    public function map($order): array
    {
        return [
            $order->id,
            $order->user->name,
            $order->user->email,
            ucfirst($order->status),
            $order->shipping_cost,
            $order->total_amount,
            $order->created_at->format('d-m-Y H:i'),
        ];
    }

    public function registerEvents(): array
    {
        return [
            AfterSheet::class => function(AfterSheet $event) {
                $sheet = $event->sheet->getDelegate();
                $lastRow = $sheet->getHighestRow();

                $totalRevenue = $this->query()->where('status', 'completed')->sum('total_amount');

                $sheet->setCellValue('E' . ($lastRow + 2), 'Total Pendapatan (Completed):');
                $sheet->setCellValue('F' . ($lastRow + 2), $totalRevenue);

                $sheet->getStyle('E' . ($lastRow + 2) . ':F' . ($lastRow + 2))->getFont()->setBold(true);
            },
        ];
    }
}