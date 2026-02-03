/// 완료 기록 모델
class Completion {
  final String id;
  final String userId;
  final String stageId;
  final DateTime completedAt;

  const Completion({
    required this.id,
    required this.userId,
    required this.stageId,
    required this.completedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Completion &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Completion(id: $id, stageId: $stageId)';
}
