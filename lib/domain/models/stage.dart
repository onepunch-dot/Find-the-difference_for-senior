import 'answer.dart';

/// 스테이지 모델
class Stage {
  final String id;
  final String themeId;
  final int stageNumber; // 테마 내 스테이지 번호 (1부터 시작)
  final String? imageAUrl; // 이미지 A URL
  final String? imageBUrl; // 이미지 B URL
  final int imageVersion; // 이미지 버전 (캐시 무효화용)
  final List<Answer> answers; // 정답 좌표 목록
  final int difficulty; // 난이도 (1~5)
  final DateTime createdAt;
  final DateTime updatedAt;

  const Stage({
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

  /// 모든 정답을 찾았는지 확인
  bool isAllAnswersFound(Set<int> foundIndices) {
    return foundIndices.length == answers.length;
  }

  /// 주어진 좌표가 정답인지 확인하고, 정답이면 인덱스 반환
  int? findAnswerIndex(double tapX, double tapY, Set<int> foundIndices) {
    for (int i = 0; i < answers.length; i++) {
      if (!foundIndices.contains(i) && answers[i].isHit(tapX, tapY)) {
        return i;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Stage(id: $id, themeId: $themeId, number: $stageNumber)';
}
