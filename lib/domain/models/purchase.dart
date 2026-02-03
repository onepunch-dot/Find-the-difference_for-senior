/// 구매 타입
enum PurchaseType {
  theme, // 테마팩 구매
  adRemoval, // 광고 제거
}

/// 사용자 구매 내역
class Purchase {
  final String id;
  final String userId;
  final PurchaseType type;
  final String? themeId; // type이 theme일 경우 테마 ID
  final String productId; // IAP 상품 ID
  final DateTime purchasedAt;

  const Purchase({
    required this.id,
    required this.userId,
    required this.type,
    this.themeId,
    required this.productId,
    required this.purchasedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Purchase && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Purchase(id: $id, type: $type, themeId: $themeId)';
}
