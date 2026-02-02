class Answer {
  final double x;
  final double y;
  final double radius;

  const Answer({
    required this.x,
    required this.y,
    required this.radius,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      radius: (json['radius'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'radius': radius,
    };
  }
}
