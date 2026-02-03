import '../../../domain/models/purchase.dart';

/// Supabase purchases 테이블 DTO
class PurchaseDto {
  final String id;
  final String userId;
  final String type; // 'theme' | 'ad_removal'
  final String? themeId;
  final String productId;
  final DateTime purchasedAt;

  const PurchaseDto({
    required this.id,
    required this.userId,
    required this.type,
    this.themeId,
    required this.productId,
    required this.purchasedAt,
  });

  factory PurchaseDto.fromJson(Map<String, dynamic> json) {
    return PurchaseDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      themeId: json['theme_id'] as String?,
      productId: json['product_id'] as String,
      purchasedAt: DateTime.parse(json['purchased_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'theme_id': themeId,
      'product_id': productId,
      'purchased_at': purchasedAt.toIso8601String(),
    };
  }

  Purchase toDomain() {
    return Purchase(
      id: id,
      userId: userId,
      type: type == 'ad_removal' ? PurchaseType.adRemoval : PurchaseType.theme,
      themeId: themeId,
      productId: productId,
      purchasedAt: purchasedAt,
    );
  }

  static PurchaseDto fromDomain(Purchase purchase) {
    return PurchaseDto(
      id: purchase.id,
      userId: purchase.userId,
      type: purchase.type == PurchaseType.adRemoval ? 'ad_removal' : 'theme',
      themeId: purchase.themeId,
      productId: purchase.productId,
      purchasedAt: purchase.purchasedAt,
    );
  }
}
