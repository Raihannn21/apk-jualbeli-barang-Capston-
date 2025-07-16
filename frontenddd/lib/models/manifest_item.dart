class ManifestItem {
  final String description;
  final DateTime dateTime;

  ManifestItem({
    required this.description,
    required this.dateTime,
  });

  factory ManifestItem.fromJson(Map<String, dynamic> json) {
    return ManifestItem(
      description: json['manifest_description'] ?? 'No description',
      dateTime:
          DateTime.parse('${json['manifest_date']} ${json['manifest_time']}'),
    );
  }
}
