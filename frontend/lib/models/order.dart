import 'order_item.dart';
import 'user_address.dart';

class Order {
  final int id;
  final String totalAmount;
  final String? shippingCost;
  final String? shippingCourier;
  final String status;
  final DateTime createdAt;
  final List<OrderItem>? items;
  final UserAddress? address;
  final String? waybill_number;
  final String? courier_code;
  // --- DATA HARGA BARU ---
  final String subtotal;
  final String discountAmount;

  Order({
    required this.id,
    required this.totalAmount,
    this.shippingCost,
    this.shippingCourier,
    required this.status,
    required this.createdAt,
    this.items,
    this.address,
    this.waybill_number,
    this.courier_code,
    required this.subtotal,
    required this.discountAmount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List?;
    List<OrderItem>? items =
        itemsList?.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: int.tryParse(json['id'].toString()) ?? 0,
      totalAmount: json['total_amount'].toString(),
      shippingCost: json['shipping_cost']?.toString(),
      shippingCourier: json['shipping_courier'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: items,
      address: json['address'] != null
          ? UserAddress.fromJson(json['address'])
          : null,
      waybill_number: json['waybill_number'],
      courier_code: json['courier_code'],
      // --- PARSING DATA HARGA BARU ---
      subtotal: json['subtotal']?.toString() ?? '0',
      discountAmount: json['discount_amount']?.toString() ?? '0',
    );
  }
}
