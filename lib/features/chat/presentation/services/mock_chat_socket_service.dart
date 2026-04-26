import 'dart:async';
import 'dart:math';

import '../models/chat_models.dart';

class ChatSocketEvent {
  const ChatSocketEvent({required this.threadId, required this.message});

  final String threadId;
  final ChatMessage message;
}

class MockChatSocketService {
  final _controller = StreamController<ChatSocketEvent>.broadcast();
  final _random = Random();

  Timer? _heartbeat;
  String? _activeThreadId;

  Stream<ChatSocketEvent> get stream => _controller.stream;

  void connect(String threadId) {
    _activeThreadId = threadId;
    _heartbeat ??= Timer.periodic(const Duration(seconds: 12), (_) {
      final active = _activeThreadId;
      if (active == null) return;
      final text = _heartbeatLines[_random.nextInt(_heartbeatLines.length)];
      _controller.add(
        ChatSocketEvent(
          threadId: active,
          message: ChatMessage(
            id: 'socket-${DateTime.now().microsecondsSinceEpoch}',
            threadId: active,
            senderName: _senderForThread(active),
            isMine: false,
            type: ChatMessageType.text,
            text: text,
            sentAt: DateTime.now(),
          ),
        ),
      );
    });
  }

  void disconnect(String threadId) {
    if (_activeThreadId == threadId) {
      _activeThreadId = null;
    }
    if (_activeThreadId == null) {
      _heartbeat?.cancel();
      _heartbeat = null;
    }
  }

  void simulateReply({required String threadId, required String fromMessage}) {
    final delay = Duration(milliseconds: 800 + _random.nextInt(1200));
    Future.delayed(delay, () {
      if (_controller.isClosed) return;
      _controller.add(
        ChatSocketEvent(
          threadId: threadId,
          message: ChatMessage(
            id: 'reply-${DateTime.now().microsecondsSinceEpoch}',
            threadId: threadId,
            senderName: _senderForThread(threadId),
            isMine: false,
            type: ChatMessageType.text,
            text: _buildReply(fromMessage),
            sentAt: DateTime.now(),
          ),
        ),
      );
    });
  }

  String _senderForThread(String threadId) {
    if (threadId == 'driver-rizky') return 'Rizky';
    if (threadId == 'food-warung-bu-tini') return 'Warung Bu Tini';
    return 'Support';
  }

  String _buildReply(String source) {
    final normalized = source.toLowerCase();
    if (normalized.contains('lokasi')) {
      return 'Siap, saya update posisi sekarang.';
    }
    if (normalized.contains('terima kasih')) {
      return 'Sama-sama kak, dengan senang hati.';
    }
    if (normalized.contains('tunggu')) {
      return 'Baik kak, saya tunggu konfirmasi dari Anda.';
    }
    if (normalized.contains('foto')) {
      return 'Foto sudah saya terima, kondisinya aman.';
    }
    return _replyPool[_random.nextInt(_replyPool.length)];
  }

  Future<void> dispose() async {
    _heartbeat?.cancel();
    await _controller.close();
  }
}

const _replyPool = <String>[
  'Siap, kami proses sekarang ya.',
  'Noted kak, terima kasih infonya.',
  'Baik, akan kami update lagi setelah progress berikutnya.',
  'Sudah kami terima, mohon ditunggu sebentar.',
];

const _heartbeatLines = <String>[
  'Update: posisi saya sudah dekat titik jemput.',
  'Traffic cukup lancar, estimasi tetap sesuai aplikasi.',
  'Pesanan Anda sedang saya prioritaskan.',
  'Jika ada catatan tambahan, langsung kirim di chat ini ya.',
];
