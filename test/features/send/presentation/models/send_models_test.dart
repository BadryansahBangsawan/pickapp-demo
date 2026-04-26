import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/features/send/presentation/models/send_models.dart';

void main() {
  test('package size base fees are increasing by size', () {
    expect(PackageSize.small.baseFee, lessThan(PackageSize.medium.baseFee));
    expect(PackageSize.medium.baseFee, lessThan(PackageSize.large.baseFee));
  });

  test('tracking steps contain final delivered status', () {
    expect(sendTrackingSteps, isNotEmpty);
    expect(sendTrackingSteps.last.toLowerCase(), contains('berhasil'));
  });
}
