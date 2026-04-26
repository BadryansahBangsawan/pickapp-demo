import 'package:flutter_test/flutter_test.dart';

import 'package:pickup/features/chat/presentation/bloc/chat_cubit.dart';

void main() {
  group('ChatCubit', () {
    late ChatCubit cubit;

    setUp(() {
      cubit = ChatCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loads mock threads on startup', () async {
      await Future<void>.delayed(const Duration(milliseconds: 760));

      expect(cubit.state.threads, isNotEmpty);
    });

    test('sending text appends outgoing message to active room', () async {
      await Future<void>.delayed(const Duration(milliseconds: 760));
      final threadId = cubit.state.threads.first.id;

      cubit.openThread(threadId);
      final before = cubit.state.messagesFor(threadId).length;

      cubit.sendTextMessage(threadId, 'Tes kirim');

      final afterMessages = cubit.state.messagesFor(threadId);
      expect(afterMessages.length, before + 1);
      expect(afterMessages.last.isMine, isTrue);
      expect(afterMessages.last.text, 'Tes kirim');
    });
  });
}
