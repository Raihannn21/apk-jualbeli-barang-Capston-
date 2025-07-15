import 'product.dart';

class CartItem {
  final int id;
  int quantity;
  final Product product;
  bool isSelected; // <-- 1. TAMBAHKAN PROPERTI BARU INI

  CartItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.isSelected =
        true, // <-- 2. Atur defaultnya terpilih semua saat pertama kali dimuat
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: int.parse(json['id'].toString()),
      quantity: json['quantity'],
      product: Product.fromJson(json['product']),
    );
  }
}
