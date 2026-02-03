import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/features/home/home_page.dart';

void main() {
  testWidgets('HomePage displays correctly', (WidgetTester tester) async {
    // HomePage 빌드 (초기화 로직 없이 UI만 테스트)
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // HomePage 요소 확인
    expect(find.text('틀린그림찾기'), findsOneWidget);
    expect(find.text('앱 초기화 완료!'), findsOneWidget);
  });
}
