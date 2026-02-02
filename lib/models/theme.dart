class GameTheme {
  final int id;
  final String title;
  final String? thumbnailPath;
  final int orderIndex;
  final bool isPublished;
  final DateTime createdAt;

  // 새로운 필드 (시니어/BM 반영)
  final bool isPaid;
  final String? priceTier;
  final List<String> previewImages;
  final String? bgmPath;
  final int bgmVersion;

  const GameTheme({
    required this.id,
    required this.title,
    this.thumbnailPath,
    required this.orderIndex,
    required this.isPublished,
    required this.createdAt,
    required this.isPaid,
    this.priceTier,
    this.previewImages = const [],
    this.bgmPath,
    this.bgmVersion = 1,
  });

  factory GameTheme.fromJson(Map<String, dynamic> json) {
    return GameTheme(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailPath: json['thumbnail_path'] as String?,
      orderIndex: json['order_index'] as int,
      isPublished: json['is_published'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      isPaid: json['is_paid'] as bool? ?? false,
      priceTier: json['price_tier'] as String?,
      previewImages: json['preview_images'] != null
          ? List<String>.from(json['preview_images'] as List)
          : [],
      bgmPath: json['bgm_path'] as String?,
      bgmVersion: json['bgm_version'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnail_path': thumbnailPath,
      'order_index': orderIndex,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
      'is_paid': isPaid,
      'price_tier': priceTier,
      'preview_images': previewImages,
      'bgm_path': bgmPath,
      'bgm_version': bgmVersion,
    };
  }
}
