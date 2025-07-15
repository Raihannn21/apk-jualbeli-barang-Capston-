import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/notification_service.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import '../tracking_screen.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;
  final bool isConfirming;
  final bool isCancelling;
  final bool isUploading;
  final VoidCallback onConfirmDelivery;
  final VoidCallback onCancelOrder;
  final VoidCallback onUploadProof;
  final VoidCallback onTrackOrder;
  final Function(Product, int) onReview;

  const OrderDetailView({
    super.key,
    required this.order,
    required this.isConfirming,
    required this.isCancelling,
    required this.isUploading,
    required this.onConfirmDelivery,
    required this.onCancelOrder,
    required this.onUploadProof,
    required this.onTrackOrder,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSectionCard(context,
                  title: 'Info Pengiriman', child: _buildShippingInfo(context)),
              const SizedBox(height: 16),
              _buildSectionCard(context,
                  title: 'Rincian Produk', child: _buildProductList(context)),
              const SizedBox(height: 16),
              _buildSectionCard(context,
                  title: 'Rincian Pembayaran',
                  child: _buildPaymentDetails(context)),
            ],
          ),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildShippingInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(context, 'Status:', order.status.toUpperCase(),
            highlight: true),
        const SizedBox(height: 12),
        Text(order.address?.recipientName ?? 'N/A',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(order.address?.phoneNumber ?? 'N/A'),
        const SizedBox(height: 4),
        Text(
            '${order.address?.address ?? ''}, ${order.address?.city ?? ''}, ${order.address?.province ?? ''} ${order.address?.postalCode ?? ''}'),
        const SizedBox(height: 12),
        _buildInfoRow(context, 'Kurir:', order.shippingCourier ?? 'N/A'),
        if (order.waybill_number != null && order.waybill_number!.isNotEmpty)
          _buildInfoRow(context, 'No. Resi:', order.waybill_number!),
      ],
    );
  }

  Widget _buildProductList(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Column(
      children: order.items?.map((item) {
            final pricePaid = double.tryParse(item.price) ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Image.network(item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.image, size: 50)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            '${formatter.format(pricePaid)} x ${item.quantity}'),
                      ],
                    ),
                  ),
                  if (order.status == 'completed')
                    TextButton(
                        onPressed: () => onReview(item.product, order.id),
                        child: const Text('Beri Ulasan'))
                ],
              ),
            );
          }).toList() ??
          [],
    );
  }

  Widget _buildPaymentDetails(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // AMBIL DATA LANGSUNG DARI OBJEK ORDER, TIDAK DIHITUNG ULANG
    final subtotal = double.tryParse(order.subtotal) ?? 0;
    final totalDiscount = double.tryParse(order.discountAmount) ?? 0;
    final shippingCost = double.tryParse(order.shippingCost ?? '0') ?? 0;
    final totalPayment = double.tryParse(order.totalAmount) ?? 0;

    return Column(
      children: [
        _buildInfoRow(context, 'Subtotal Produk', formatter.format(subtotal)),
        if (totalDiscount > 0)
          _buildInfoRow(
              context, 'Total Diskon', '- ${formatter.format(totalDiscount)}',
              textColor: Colors.green),
        const SizedBox(height: 8),
        _buildInfoRow(context, 'Ongkos Kirim', formatter.format(shippingCost)),
        const Divider(height: 24),
        _buildInfoRow(
            context, 'Total Pembayaran', formatter.format(totalPayment),
            isTotal: true),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tampilkan tombol Lacak Paket jika nomor resi ada
          if (order.waybill_number != null && order.waybill_number!.isNotEmpty)
            ElevatedButton.icon(
              icon: const Icon(Icons.track_changes_outlined),
              label: const Text('Lacak Paket'),
              // --- PERUBAHAN DI SINI ---
              onPressed: () {
                // Ganti navigasi dengan notifikasi
                NotificationService.showInfoNotification(
                  context,
                  'Fitur Lacak Paket akan segera tersedia!',
                );
              },
              // --------------------------
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.black),
            ),

          // Beri jarak jika kedua tombol muncul
          if (order.waybill_number != null &&
              order.waybill_number!.isNotEmpty &&
              order.status == 'shipped')
            const SizedBox(height: 8),

          // Tombol Konfirmasi Diterima (tidak berubah)
          if (order.status == 'shipped')
            ElevatedButton(
              onPressed: isConfirming ? null : onConfirmDelivery,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: isConfirming
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Pesanan Sudah Diterima'),
            ),

          // Tombol untuk status 'pending' (tidak berubah)
          if (order.status == 'pending') ...[
            ElevatedButton.icon(
              onPressed: isUploading ? null : onUploadProof,
              icon: isUploading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.upload_file),
              label: const Text('Upload Bukti Pembayaran'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: isCancelling ? null : onCancelOrder,
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red),
              child: isCancelling
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Batalkan Pesanan'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16.0), child: child),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isTotal = false, bool highlight = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                  fontSize: isTotal ? 18 : 16,
                  color: textColor ??
                      (highlight
                          ? Colors.orange.shade800
                          : Theme.of(context).textTheme.bodyLarge?.color))),
        ],
      ),
    );
  }
}
