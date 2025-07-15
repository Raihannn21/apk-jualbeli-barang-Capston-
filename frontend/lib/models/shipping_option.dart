// lib/models/shipping_option.dart
class ShippingOption {
  final String code; // Contoh: 'tiki'
  final String name; // Contoh: 'Citra Van Titipan Kilat (TIKI)'
  final String service; // Contoh: 'REG'
  final String description; // Contoh: 'Reguler Service'
  final int price;
  final String etd; // Estimasi dalam hari

  ShippingOption({
    required this.code,
    required this.name,
    required this.service,
    required this.description,
    required this.price,
    required this.etd,
  });

  // Untuk perbandingan objek di RadioListTile
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShippingOption &&
        other.code == code &&
        other.service == service;
  }

  @override
  int get hashCode => code.hashCode ^ service.hashCode;
}
