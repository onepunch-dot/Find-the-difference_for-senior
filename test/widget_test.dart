import 'package:flutter_test/flutter_test.dart';
import 'package:find_difference_app/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // 앱 빌드
    await tester.pumpWidget(const MyApp());

    // 로딩 페이지가 표시되는지 확인
    expect(find.text('로딩 중...'), findsOneWidget);
  });
}
