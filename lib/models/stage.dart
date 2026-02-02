import 'answer.dart';

class Stage {
  final int id;
  final int themeId;
  final String title;
  final String imageAPath;
  final String imageBPath;
  final List<Answer> answers;
  final int totalAnswers;
  final int imageWidth;
  final int imageHeight;
  final int imageAVersion;
  final int imageBVersion;
  final int orderIndex;
  final bool isPublished;
  final DateTime createdAt;

  // 새로운 필드 (시니어 UX)
  final int difficulty;
  final List<Answer>? hintPoints;

  const Stage({
    required this.id,
    required this.themeId,
    required this.title,
    required this.imageAPath,
    required this.imageBPath,
    required this.answers,
    required this.totalAnswers,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageAVersion,
    required this.imageBVersion,
    required this.orderIndex,
    required this.isPublished,
    required this.createdAt,
    this.difficulty = 1,
    this.hintPoints,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as List;
    final answers = answersJson.map((a) => Answer.fromJson(a)).toList();

    List<Answer>? hintPoints;
    if (json['hint_points'] != null) {
      final hintJson = json['hint_points'] as List;
      hintPoints = hintJson.map((h) => Answer.fromJson(h)).toList();
    }

    return Stage(
      id: json['id'] as int,
      themeId: json['theme_id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      imageAPath: json['imagea_path'] as String? ?? '',
      imageBPath: json['imageb_path'] as String? ?? '',
      answers: answers,
      totalAnswers: json['total_answers'] as int? ?? 0,
      imageWidth: json['image_width'] as int? ?? 2048,
      imageHeight: json['image_height'] as int? ?? 1536,
      imageAVersion: json['imagea_version'] as int? ?? 1,
      imageBVersion: json['imageb_version'] as int? ?? 1,
      orderIndex: json['order_index'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      difficulty: json['difficulty'] as int? ?? 1,
      hintPoints: hintPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme_id': themeId,
      'title': title,
      'imagea_path': imageAPath,
      'imageb_path': imageBPath,
      'answers': answers.map((a) => a.toJson()).toList(),
      'total_answers': totalAnswers,
      'image_width': imageWidth,
      'image_height': imageHeight,
      'imagea_version': imageAVersion,
      'imageb_version': imageBVersion,
      'order_index': orderIndex,
      'is_published': isPublished,
      'created_at': createdAt.toIso8601String(),
      'difficulty': difficulty,
      'hint_points': hintPoints?.map((h) => h.toJson()).toList(),
    };
  }
}
