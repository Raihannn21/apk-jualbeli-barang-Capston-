class ShippingOption {
  final String code;
  final String name;
  final String service;
  final String description;
  final int price;
  final String etd;

  ShippingOption({
    required this.code,
    required this.name,
    required this.service,
    required this.description,
    required this.price,
    required this.etd,
  });

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
