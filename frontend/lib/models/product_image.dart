// lib/models/product_image.dart
class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({required this.id, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imageUrl: json['image_url'],
    );
  }
}
