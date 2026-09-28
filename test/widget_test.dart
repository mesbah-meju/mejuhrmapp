import 'package:flutter_test/flutter_test.dart';
import 'package:auth_ui_app/main.dart';

void main() {
  testWidgets('Auth UI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuthUiApp());
    expect(find.text('Skip'), findsOneWidget);
  });
}
