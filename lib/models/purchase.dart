class Purchase {
  final int id;
  final String deviceId;
  final int themeId;
  final String productId;
  final DateTime purchasedAt;

  const Purchase({
    required this.id,
    required this.deviceId,
    required this.themeId,
    required this.productId,
    required this.purchasedAt,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as int,
      deviceId: json['device_id'] as String,
      themeId: json['theme_id'] as int,
      productId: json['product_id'] as String,
      purchasedAt: DateTime.parse(json['purchased_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'theme_id': themeId,
      'product_id': productId,
      'purchased_at': purchasedAt.toIso8601String(),
    };
  }
}
