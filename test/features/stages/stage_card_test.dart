import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/features/stages/widgets/stage_card.dart';
import 'package:find_difference_app/features/stages/models/stage_status.dart';
import 'package:find_difference_app/domain/models/stage.dart';
import 'package:find_difference_app/domain/models/answer.dart';

void main() {
  group('StageCard', () {
    testWidgets('displays available stage correctly', (WidgetTester tester) async {
      // Arrange
      final stage = Stage(
        id: '1',
        themeId: 'theme1',
        stageNumber: 1,
        imageVersion: 1,
        answers: const [Answer(x: 0.5, y: 0.5, radius: 0.1)],
        difficulty: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final stageWithStatus = StageWithStatus(
        stage: stage,
        status: StageStatus.available,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageCard(
              stageWithStatus: stageWithStatus,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Stage 1'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsNothing);
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('displays completed stage with checkmark', (WidgetTester tester) async {
      // Arrange
      final stage = Stage(
        id: '2',
        themeId: 'theme1',
        stageNumber: 2,
        imageVersion: 1,
        answers: const [Answer(x: 0.5, y: 0.5, radius: 0.1)],
        difficulty: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final stageWithStatus = StageWithStatus(
        stage: stage,
        status: StageStatus.completed,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageCard(
              stageWithStatus: stageWithStatus,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Stage 2'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays locked stage with lock icon', (WidgetTester tester) async {
      // Arrange
      final stage = Stage(
        id: '3',
        themeId: 'theme1',
        stageNumber: 3,
        imageVersion: 1,
        answers: const [Answer(x: 0.5, y: 0.5, radius: 0.1)],
        difficulty: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final stageWithStatus = StageWithStatus(
        stage: stage,
        status: StageStatus.locked,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StageCard(
              stageWithStatus: stageWithStatus,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Stage 3'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });
  });
}
