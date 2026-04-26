import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/app.dart';

void main() {
  testWidgets('App boots into splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PickUpApp());
    await tester.pump();
    expect(find.text('Pick Up'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 1300));
  });
}
