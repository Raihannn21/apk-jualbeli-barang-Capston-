import 'product.dart';

class CartItem {
  final int id;
  int quantity;
  final Product product;
  bool isSelected;

  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.isSelected = true,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: int.parse(json['id'].toString()),
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }
}
