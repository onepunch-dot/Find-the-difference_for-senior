/// 정답 위치 (원형 좌표)
class Answer {
  final double x; // 0.0 ~ 1.0 (이미지 너비 기준 비율)
  final double y; // 0.0 ~ 1.0 (이미지 높이 기준 비율)
  final double radius; // 0.0 ~ 1.0 (이미지 크기 기준 비율)

  const Answer({
    required this.x,
    required this.y,
    required this.radius,
  });

  /// 주어진 좌표(tapX, tapY)가 정답 범위 내에 있는지 판정
  bool isHit(double tapX, double tapY) {
    final dx = tapX - x;
    final dy = tapY - y;
    final distance = dx * dx + dy * dy;
    return distance <= radius * radius;
  }

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'radius': radius,
      };

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        radius: (json['radius'] as num).toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Answer &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          radius == other.radius;

  @override
  int get hashCode => Object.hash(x, y, radius);

  @override
  String toString() => 'Answer(x: $x, y: $y, radius: $radius)';
}
