import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:pickup/features/profile/presentation/models/profile_models.dart';

void main() {
  group('ProfileCubit', () {
    late ProfileCubit cubit;

    setUp(() {
      cubit = ProfileCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('add, update, and delete address works', () {
      final newAddress = SavedAddress(
        id: 'test-id',
        label: 'Gudang',
        address: 'Jl. Testing No. 1',
      );

      cubit.addAddress(newAddress);
      expect(cubit.state.addresses.any((a) => a.id == 'test-id'), isTrue);

      cubit.updateAddress(
        newAddress.copyWith(address: 'Jl. Testing No. 2', notes: 'Catatan'),
      );
      final updated = cubit.state.addresses.firstWhere(
        (a) => a.id == 'test-id',
      );
      expect(updated.address, 'Jl. Testing No. 2');
      expect(updated.notes, 'Catatan');

      cubit.deleteAddress('test-id');
      expect(cubit.state.addresses.any((a) => a.id == 'test-id'), isFalse);
    });

    test('toggle settings updates state', () {
      cubit.toggleNotifications(false);
      cubit.toggleLanguage(true);

      expect(cubit.state.notificationsEnabled, isFalse);
      expect(cubit.state.useEnglish, isTrue);
    });
  });
}
