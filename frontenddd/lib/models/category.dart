class Category {
  final int id;
  final String name;
  final String slug;
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
