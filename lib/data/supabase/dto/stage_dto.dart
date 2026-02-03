import 'dart:convert';
import '../../../domain/models/answer.dart';
import '../../../domain/models/stage.dart';

/// Supabase stages 테이블 DTO
class StageDto {
  final String id;
  final String themeId;
  final int stageNumber;
  final String? imageAUrl;
  final String? imageBUrl;
  final int imageVersion;
  final List<Answer> answers;
  final int difficulty;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StageDto({
    required this.id,
    required this.themeId,
    required this.stageNumber,
    this.imageAUrl,
    this.imageBUrl,
    required this.imageVersion,
    required this.answers,
    required this.difficulty,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StageDto.fromJson(Map<String, dynamic> json) {
    // answers는 JSON 배열로 저장되어 있음
    final answersJson = json['answers'];
    List<Answer> answersList = [];

    if (answersJson is String) {
      // String으로 저장된 경우 파싱
      final decoded = jsonDecode(answersJson) as List;
      answersList = decoded.map((e) => Answer.fromJson(e as Map<String, dynamic>)).toList();
    } else if (answersJson is List) {
      // 이미 List인 경우
      answersList = answersJson.map((e) => Answer.fromJson(e as Map<String, dynamic>)).toList();
    }

    return StageDto(
      id: json['id'] as String,
      themeId: json['theme_id'] as String,
      stageNumber: json['stage_number'] as int,
      imageAUrl: json['image_a_url'] as String?,
      imageBUrl: json['image_b_url'] as String?,
      imageVersion: json['image_version'] as int,
      answers: answersList,
      difficulty: json['difficulty'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Stage toDomain() {
    return Stage(
      id: id,
      themeId: themeId,
      stageNumber: stageNumber,
      imageAUrl: imageAUrl,
      imageBUrl: imageBUrl,
      imageVersion: imageVersion,
      answers: answers,
      difficulty: difficulty,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
