import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/features/stage_play/stage_viewmodel.dart';
import 'package:find_difference_app/domain/models/stage.dart';
import 'package:find_difference_app/domain/models/answer.dart';

void main() {
  group('StageViewModel', () {
    late Stage testStage;
    late StageViewModel viewModel;

    setUp(() {
      testStage = Stage(
        id: 'test',
        themeId: 'theme1',
        stageNumber: 1,
        imageVersion: 1,
        answers: const [
          Answer(x: 0.5, y: 0.5, radius: 0.1), // 중앙
          Answer(x: 0.2, y: 0.3, radius: 0.05), // 좌상단
          Answer(x: 0.8, y: 0.7, radius: 0.08), // 우하단
        ],
        difficulty: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      viewModel = StageViewModel(stage: testStage);
    });

    test('초기 상태가 올바른지', () {
      expect(viewModel.foundCount, 0);
      expect(viewModel.totalCount, 3);
      expect(viewModel.isCompleted, false);
      expect(viewModel.progress, 0.0);
    });

    test('정답을 찾으면 foundAnswers에 추가', () {
      // 첫 번째 정답 (중앙) 탭
      final isCorrect = viewModel.checkAnswer(0.5, 0.5);

      expect(isCorrect, true);
      expect(viewModel.foundCount, 1);
      expect(viewModel.isCompleted, false);
    });

    test('오답을 탭하면 foundAnswers에 추가되지 않음', () {
      // 정답이 없는 위치 탭
      final isCorrect = viewModel.checkAnswer(0.9, 0.1);

      expect(isCorrect, false);
      expect(viewModel.foundCount, 0);
    });

    test('모든 정답을 찾으면 완료 상태', () {
      // 3개 정답 모두 찾기
      viewModel.checkAnswer(0.5, 0.5); // 첫 번째
      viewModel.checkAnswer(0.2, 0.3); // 두 번째
      viewModel.checkAnswer(0.8, 0.7); // 세 번째

      expect(viewModel.foundCount, 3);
      expect(viewModel.isCompleted, true);
      expect(viewModel.progress, 1.0);
    });

    test('이미 찾은 정답을 다시 탭하면 무시', () {
      // 첫 번째 정답 찾기
      viewModel.checkAnswer(0.5, 0.5);
      expect(viewModel.foundCount, 1);

      // 같은 위치 다시 탭
      final isCorrect = viewModel.checkAnswer(0.5, 0.5);
      expect(isCorrect, false);
      expect(viewModel.foundCount, 1); // 변화 없음
    });

    test('힌트 사용 시 다음 정답 반환', () {
      // 첫 번째 정답 찾기
      viewModel.checkAnswer(0.5, 0.5);

      // 힌트 사용
      final hint = viewModel.useHint();

      expect(hint, isNotNull);
      expect(hint!.x, 0.2);
      expect(hint.y, 0.3);
    });

    test('모든 정답을 찾은 후 힌트 사용 시 null', () {
      // 모든 정답 찾기
      viewModel.checkAnswer(0.5, 0.5);
      viewModel.checkAnswer(0.2, 0.3);
      viewModel.checkAnswer(0.8, 0.7);

      // 힌트 사용
      final hint = viewModel.useHint();

      expect(hint, isNull);
    });

    test('리셋 후 초기 상태로 돌아감', () {
      // 정답 찾기
      viewModel.checkAnswer(0.5, 0.5);
      expect(viewModel.foundCount, 1);

      // 리셋
      viewModel.reset();

      expect(viewModel.foundCount, 0);
      expect(viewModel.isCompleted, false);
    });
  });
}
