import 'package:flutter/foundation.dart';
import '../../domain/models/stage.dart';
import '../../domain/models/answer.dart';

/// StagePage 상태 관리
class StageViewModel extends ChangeNotifier {
  final Stage stage;

  StageViewModel({required this.stage});

  // 상태
  final Set<int> _foundAnswers = {};
  bool _isCompleted = false;

  // Getters
  Set<int> get foundAnswers => _foundAnswers;
  int get foundCount => _foundAnswers.length;
  int get totalCount => stage.answers.length;
  bool get isCompleted => _isCompleted;
  double get progress => totalCount > 0 ? foundCount / totalCount : 0;

  /// 탭 위치 확인 (정답 판정)
  /// tapX, tapY: 이미지 기준 0.0~1.0 비율 좌표
  bool checkAnswer(double tapX, double tapY) {
    // 아직 찾지 않은 정답 중에서 hit 체크
    final answerIndex = stage.findAnswerIndex(tapX, tapY, _foundAnswers);

    if (answerIndex != null) {
      // 정답 발견!
      _foundAnswers.add(answerIndex);

      // 모든 정답을 찾았는지 확인
      if (_foundAnswers.length == stage.answers.length) {
        _isCompleted = true;
      }

      notifyListeners();
      return true;
    }

    // 오답
    return false;
  }

  /// 힌트 사용 (다음 정답 하나 공개)
  Answer? useHint() {
    // 아직 찾지 않은 정답 중 첫 번째 반환
    for (int i = 0; i < stage.answers.length; i++) {
      if (!_foundAnswers.contains(i)) {
        return stage.answers[i];
      }
    }
    return null;
  }

  /// 리셋 (재시작)
  void reset() {
    _foundAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }
}
