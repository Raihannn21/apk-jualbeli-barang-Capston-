import 'product_image.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String imageUrl;
  final List<ProductImage> images;
  final String? discountPrice;
  final int? discountPercent;
  // --- PROPERTI BARU ---
  final double averageRating;
  final int reviewsCount;
  final int soldCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.images,
    this.discountPrice,
    this.discountPercent,
    required this.averageRating, // <-- Tambahkan
    required this.reviewsCount, // <-- Tambahkan
    required this.soldCount, // <-- Tambahkan
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List?;
    List<ProductImage> productImages =
        imageList?.map((i) => ProductImage.fromJson(i)).toList() ?? [];

    return Product(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toString() ?? '0',
      stock: int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      imageUrl: json['image_url'] ?? '',
      images: productImages,
      discountPrice: json['discount_price']?.toString(),
      discountPercent:
          int.tryParse(json['discount_percent']?.toString() ?? '0'),
      // --- LOGIKA PARSING BARU ---
      averageRating:
          double.tryParse(json['reviews_avg_rating']?.toString() ?? '0.0') ??
              0.0,
      reviewsCount: int.tryParse(json['reviews_count']?.toString() ?? '0') ?? 0,
      soldCount: int.tryParse(json['sold_count']?.toString() ?? '0') ?? 0,
    );
  }
}
