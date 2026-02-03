import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/features/home/widgets/theme_card.dart';
import 'package:find_difference_app/features/home/models/theme_status.dart';
import 'package:find_difference_app/domain/models/theme.dart' as app_theme;

void main() {
  testWidgets('ThemeCard displays free theme correctly', (WidgetTester tester) async {
    // Arrange
    final theme = app_theme.Theme(
      id: '1',
      name: '테스트 테마',
      nameEn: 'Test Theme',
      description: '설명',
      descriptionEn: 'Description',
      isFree: true,
      bgmVersion: 1,
      order: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final themeWithStatus = ThemeWithStatus(
      theme: theme,
      status: ThemeStatus.free,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ThemeCard(
            themeWithStatus: themeWithStatus,
            onTap: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('테스트 테마'), findsOneWidget);
    expect(find.text('무료'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsNothing);
  });

  testWidgets('ThemeCard displays locked theme correctly', (WidgetTester tester) async {
    // Arrange
    final theme = app_theme.Theme(
      id: '2',
      name: '잠긴 테마',
      nameEn: 'Locked Theme',
      description: '설명',
      descriptionEn: 'Description',
      isFree: false,
      price: 1000,
      bgmVersion: 1,
      order: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final themeWithStatus = ThemeWithStatus(
      theme: theme,
      status: ThemeStatus.locked,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ThemeCard(
            themeWithStatus: themeWithStatus,
            onTap: () {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('잠긴 테마'), findsOneWidget);
    expect(find.text('잠김'), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });
}
