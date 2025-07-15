// lib/models/waybill.dart
import 'manifest_item.dart';

class Waybill {
  final String courierName;
  final String waybillNumber;
  final String status;
  final String receiver;
  final List<ManifestItem> manifest;

  Waybill({
    required this.courierName,
    required this.waybillNumber,
    required this.status,
    required this.receiver,
    required this.manifest,
  });

  factory Waybill.fromJson(Map<String, dynamic> json) {
    var manifestList = json['manifest'] as List;
    List<ManifestItem> manifestItems =
        manifestList.map((i) => ManifestItem.fromJson(i)).toList();

    // Urutkan manifest dari yang terbaru ke terlama
    manifestItems.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Waybill(
      courierName: json['summary']['courier_name'] ?? '',
      waybillNumber: json['summary']['waybill_number'] ?? '',
      status: json['summary']['status'] ?? '',
      receiver: json['details']['receiver_name'] ?? '',
      manifest: manifestItems,
    );
  }
}
