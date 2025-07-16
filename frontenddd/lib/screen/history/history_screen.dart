import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';
import 'order_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = OrderService().getOrders();
    });
  }

  Map<String, List<Order>> _groupOrdersByMonth(List<Order> orders) {
    final grouped = groupBy(orders, (Order order) {
      return DateFormat('MMMM yyyy', 'id_ID').format(order.createdAt);
    });
    return grouped;
  }

  Widget _getStatusIcon(String status) {
    IconData iconData;
    Color color;
    switch (status) {
      case 'pending':
        iconData = Icons.hourglass_empty_rounded;
        color = Colors.orange;
        break;
      case 'paid':
        iconData = Icons.receipt_long_outlined;
        color = Colors.blue;
        break;
      case 'shipped':
        iconData = Icons.local_shipping_outlined;
        color = Colors.indigo;
        break;
      case 'completed':
        iconData = Icons.check_circle_outline_rounded;
        color = Colors.green;
        break;
      case 'cancelled':
        iconData = Icons.cancel_outlined;
        color = Colors.red;
        break;
      default:
        iconData = Icons.help_outline;
        color = Colors.grey;
    }
    return Icon(iconData, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshOrders(),
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('Anda belum memiliki riwayat pesanan.'));
            }

            final groupedOrders = _groupOrdersByMonth(snapshot.data!);
            final months = groupedOrders.keys.toList();

            return AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final month = months[index];
                  final ordersInMonth = groupedOrders[month]!;

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.0, bottom: 8.0),
                              child: Text(
                                month,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                            ...ordersInMonth
                                .map((order) => _buildOrderItem(order))
                                .toList(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderDetailScreen(orderId: order.id)),
        ).then((_) => _refreshOrders());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1.0))),
        child: Row(
          children: [
            _getStatusIcon(order.status),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pesanan #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm', 'id_ID')
                        .format(order.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              formatter.format(double.tryParse(order.totalAmount) ?? 0),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
