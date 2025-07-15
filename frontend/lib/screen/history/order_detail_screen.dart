import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import '../../services/order_service.dart';
import '../../services/review_service.dart';
import '../../services/notification_service.dart';
import 'widgets/order_detail_view.dart';
import 'tracking_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<Order> _orderDetailFuture;
  final OrderService _orderService = OrderService();
  final ReviewService _reviewService = ReviewService();

  // State untuk mengontrol loading pada tombol
  bool _isConfirming = false;
  bool _isCancelling = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _refreshOrderDetails();
  }

  void _refreshOrderDetails() {
    setState(() {
      _orderDetailFuture = _orderService.getOrderById(widget.orderId);
    });
  }

  void _handleConfirmDelivery() async {
    setState(() {
      _isConfirming = true;
    });
    try {
      await _orderService.confirmDelivery(widget.orderId);
      if (mounted) {
        NotificationService.showSuccessNotification(
            context, 'Terima kasih atas konfirmasinya!');
      }
      _refreshOrderDetails();
    } catch (e) {
      if (mounted) {
        NotificationService.showErrorNotification(context, e.toString());
      }
    } finally {
      if (mounted)
        setState(() {
          _isConfirming = false;
        });
    }
  }

  void _handleCancelOrder() async {
    final bool? shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: const Text('Anda yakin? Stok produk akan dikembalikan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Tidak')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Ya, Batalkan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldCancel != true) return;

    setState(() {
      _isCancelling = true;
    });
    try {
      await _orderService.cancelOrder(widget.orderId);
      if (mounted) {
        NotificationService.showInfoNotification(
            context, 'Pesanan telah dibatalkan.');
      }
      _refreshOrderDetails();
    } catch (e) {
      if (mounted) {
        NotificationService.showErrorNotification(context, e.toString());
      }
    } finally {
      if (mounted)
        setState(() {
          _isCancelling = false;
        });
    }
  }

  void _handleUploadProof() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _isUploading = true;
    });
    try {
      await _orderService.uploadPaymentProof(
          widget.orderId, File(pickedFile.path));
      if (mounted) {
        NotificationService.showSuccessNotification(
            context, 'Bukti pembayaran berhasil di-upload!');
      }
      _refreshOrderDetails();
    } catch (e) {
      if (mounted) {
        NotificationService.showErrorNotification(context, e.toString());
      }
    } finally {
      if (mounted)
        setState(() {
          _isUploading = false;
        });
    }
  }

  void _handleTrackOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackingScreen(orderId: widget.orderId),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, Product product, int orderId) {
    final commentController = TextEditingController();
    int rating = 0;
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ulas: ${product.name}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Beri rating Anda:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              rating = index + 1;
                            });
                          },
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Tulis komentar Anda di sini (opsional)...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: rating == 0 || isSubmitting
                      ? null
                      : () async {
                          setDialogState(() => isSubmitting = true);
                          try {
                            await _reviewService.addReview(
                              productId: product.id,
                              orderId: orderId,
                              rating: rating,
                              comment: commentController.text,
                            );
                            Navigator.of(context).pop();
                            NotificationService.showSuccessNotification(context,
                                'Ulasan berhasil dikirim! Terima kasih.');
                            _refreshOrderDetails();
                          } catch (e) {
                            if (mounted) {
                              NotificationService.showErrorNotification(
                                  context, e.toString());
                            }
                          } finally {
                            if (mounted) {
                              setDialogState(() => isSubmitting = false);
                            }
                          }
                        },
                  child: isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Kirim Ulasan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pesanan #${widget.orderId}')),
      body: FutureBuilder<Order>(
        future: _orderDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(
                child: Text('Data detail pesanan tidak ditemukan.'));
          }

          final order = snapshot.data!;

          return OrderDetailView(
            order: order,
            isCancelling: _isCancelling,
            isConfirming: _isConfirming,
            isUploading: _isUploading,
            onCancelOrder: _handleCancelOrder,
            onConfirmDelivery: _handleConfirmDelivery,
            onUploadProof: _handleUploadProof,
            onTrackOrder: _handleTrackOrder,
            onReview: (product, orderId) =>
                _showReviewDialog(context, product, orderId),
          );
        },
      ),
    );
  }
}
