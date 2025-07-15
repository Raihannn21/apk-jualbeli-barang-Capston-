// lib/models/user_address.dart

class UserAddress {
  final int id;
  final int cityId; // <-- Kolom penting untuk RajaOngkir
  final String label;
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isPrimary;

  UserAddress({
    required this.id,
    required this.cityId,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.isPrimary,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      cityId: int.tryParse(json['city_id']?.toString() ?? '0') ?? 0,
      label: json['label'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      province: json['province'] ?? '',
      postalCode: json['postal_code'] ?? '',
      isPrimary: json['is_primary'] == 1 || json['is_primary'] == true,
    );
  }
}
