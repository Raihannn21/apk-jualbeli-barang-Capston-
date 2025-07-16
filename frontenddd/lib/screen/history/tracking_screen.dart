import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../models/waybill.dart';
import '../../services/order_service.dart';

class TrackingScreen extends StatefulWidget {
  final int orderId;
  const TrackingScreen({super.key, required this.orderId});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  late Future<Waybill> _trackingFuture;

  @override
  void initState() {
    super.initState();
    _trackingFuture = OrderService().trackOrder(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lacak Pengiriman'),
      ),
      body: FutureBuilder<Waybill>(
        future: _trackingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Gagal melacak pengiriman: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data pelacakan tidak ditemukan.'));
          }

          final waybill = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildSummaryCard(waybill),
              const SizedBox(height: 24),
              Text('Riwayat Perjalanan',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ..._buildManifestTimeline(waybill.manifest),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(Waybill waybill) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(waybill.courierName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('No. Resi: ${waybill.waybillNumber}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Status: ${waybill.status}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Penerima: ${waybill.receiver}'),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildManifestTimeline(List<dynamic> manifest) {
    List<Widget> timeline = [];
    for (int i = 0; i < manifest.length; i++) {
      final item = manifest[i];
      timeline.add(TimelineTile(
        alignment: TimelineAlign.manual,
        lineXY: 0.1,
        isFirst: i == 0,
        isLast: i == manifest.length - 1,
        indicatorStyle: IndicatorStyle(
          width: 20,
          color: Theme.of(context).primaryColor,
          indicator: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == 0 ? Colors.green : Theme.of(context).primaryColor,
            ),
            child: Center(
              child: i == 0
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ),
        ),
        endChild: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('d MMM yyyy, HH:mm').format(item.dateTime),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(item.description),
            ],
          ),
        ),
      ));
    }
    return timeline;
  }
}
