import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/core/widgets/pickup_empty_state.dart';

void main() {
  testWidgets('renders title, message, and action callback works', (
    WidgetTester tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupEmptyState(
            title: 'Kosong',
            message: 'Belum ada data',
            actionLabel: 'Muat ulang',
            onAction: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Kosong'), findsOneWidget);
    expect(find.text('Belum ada data'), findsOneWidget);
    expect(find.text('Muat ulang'), findsOneWidget);

    await tester.tap(find.text('Muat ulang'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
