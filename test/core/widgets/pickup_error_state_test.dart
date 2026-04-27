import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/core/widgets/pickup_error_state.dart';

void main() {
  testWidgets('auto detects network errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupErrorState.auto(message: 'Koneksi internet terputus'),
        ),
      ),
    );

    expect(find.text('Koneksi tidak stabil'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
  });

  testWidgets('auto falls back to server variant', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupErrorState.auto(message: 'Gagal memuat data.'),
        ),
      ),
    );

    expect(find.text('Server sedang bermasalah'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
  });

  testWidgets('server constructor applies custom title and message', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PickupErrorState.server(
            title: 'Server Down',
            message: 'Silakan coba lagi nanti.',
          ),
        ),
      ),
    );

    expect(find.text('Server Down'), findsOneWidget);
    expect(find.text('Silakan coba lagi nanti.'), findsOneWidget);
  });
}
