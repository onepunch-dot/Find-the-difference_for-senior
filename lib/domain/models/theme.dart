/// 테마 모델
class Theme {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String? thumbnailUrl;
  final bool isFree;
  final int? price; // 원타임 결제 가격 (원), null이면 무료
  final String? bgmUrl; // 테마 BGM URL
  final int bgmVersion; // BGM 버전 (캐시 무효화용)
  final int order; // 정렬 순서
  final DateTime createdAt;
  final DateTime updatedAt;

  const Theme({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    this.thumbnailUrl,
    required this.isFree,
    this.price,
    this.bgmUrl,
    required this.bgmVersion,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Theme && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Theme(id: $id, name: $name)';
}
