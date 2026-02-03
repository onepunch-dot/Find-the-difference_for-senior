import '../../../domain/models/theme.dart';

/// Supabase themes 테이블 DTO
class ThemeDto {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String? thumbnailUrl;
  final bool isFree;
  final int? price;
  final String? bgmUrl;
  final int bgmVersion;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ThemeDto({
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

  factory ThemeDto.fromJson(Map<String, dynamic> json) {
    return ThemeDto(
      id: json['id'] as String,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String,
      descriptionEn: json['description_en'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      isFree: json['is_free'] as bool,
      price: json['price'] as int?,
      bgmUrl: json['bgm_url'] as String?,
      bgmVersion: json['bgm_version'] as int,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Theme toDomain() {
    return Theme(
      id: id,
      name: name,
      nameEn: nameEn,
      description: description,
      descriptionEn: descriptionEn,
      thumbnailUrl: thumbnailUrl,
      isFree: isFree,
      price: price,
      bgmUrl: bgmUrl,
      bgmVersion: bgmVersion,
      order: order,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
