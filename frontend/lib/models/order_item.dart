import 'product.dart';

class OrderItem {
  final int quantity;
  final String price;
  final Product product;

  OrderItem({
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      quantity: json['quantity'],
      price: json['price'],
      product: Product.fromJson(json['product']),
    );
  }
}
