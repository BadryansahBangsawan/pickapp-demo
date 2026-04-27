import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/ui_error_message.dart';
import '../models/chat_models.dart';
import '../services/mock_chat_socket_service.dart';

const _activeThreadSentinel = Object();

class ChatState extends Equatable {
  const ChatState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.threads = const <ChatThread>[],
    this.messagesByThread = const <String, List<ChatMessage>>{},
    this.activeThreadId,
  });

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final List<ChatThread> threads;
  final Map<String, List<ChatMessage>> messagesByThread;
  final String? activeThreadId;

  bool get hasError => (errorMessage ?? '').isNotEmpty;

  List<ChatMessage> messagesFor(String threadId) {
    return messagesByThread[threadId] ?? const <ChatMessage>[];
  }

  ChatState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
    List<ChatThread>? threads,
    Map<String, List<ChatMessage>>? messagesByThread,
    Object? activeThreadId = _activeThreadSentinel,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      threads: threads ?? this.threads,
      messagesByThread: messagesByThread ?? this.messagesByThread,
      activeThreadId: activeThreadId == _activeThreadSentinel
          ? this.activeThreadId
          : activeThreadId as String?,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    errorMessage,
    threads,
    messagesByThread,
    activeThreadId,
  ];
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({MockChatSocketService? socketService})
    : _socketService = socketService ?? MockChatSocketService(),
      super(const ChatState()) {
    _socketSub = _socketService.stream.listen(_onSocketEvent);
    loadThreads();
  }

  final MockChatSocketService _socketService;
  final _random = Random();

  StreamSubscription<ChatSocketEvent>? _socketSub;

  Future<void> loadThreads({bool force = false, bool refresh = false}) async {
    if ((state.isLoading || state.isRefreshing) && !force) return;

    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearError: true,
      ),
    );

    try {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final threads = buildMockChatThreads();
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          threads: threads,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: mapUiErrorMessage(
            error,
            fallbackMessage: 'Gagal memuat daftar chat. Coba lagi.',
          ),
        ),
      );
    }
  }

  Future<void> refreshThreads() async {
    await loadThreads(force: true, refresh: true);
  }

  void openThread(String threadId) {
    final currentMessages = state.messagesFor(threadId);
    final nextMessages = {...state.messagesByThread};

    if (currentMessages.isEmpty) {
      nextMessages[threadId] = initialMessagesForThread(threadId);
    }

    final threads = state.threads
        .map(
          (thread) =>
              thread.id == threadId ? thread.copyWith(unreadCount: 0) : thread,
        )
        .toList();

    emit(
      state.copyWith(
        messagesByThread: nextMessages,
        threads: threads,
        activeThreadId: threadId,
      ),
    );

    _socketService.connect(threadId);
  }

  void closeActiveThread() {
    final active = state.activeThreadId;
    if (active == null) return;
    _socketService.disconnect(active);
    emit(state.copyWith(activeThreadId: null));
  }

  void sendTextMessage(String threadId, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final outgoing = ChatMessage(
      id: 'out-${DateTime.now().microsecondsSinceEpoch}',
      threadId: threadId,
      senderName: 'Anda',
      isMine: true,
      type: ChatMessageType.text,
      text: trimmed,
      sentAt: DateTime.now(),
    );

    _appendMessage(threadId: threadId, message: outgoing);
    _socketService.simulateReply(threadId: threadId, fromMessage: trimmed);
  }

  void sendQuickReply(String threadId, String text) {
    sendTextMessage(threadId, text);
  }

  void sendDummyImage(String threadId) {
    final url = chatDummyImageUrls[_random.nextInt(chatDummyImageUrls.length)];
    final outgoing = ChatMessage(
      id: 'img-${DateTime.now().microsecondsSinceEpoch}',
      threadId: threadId,
      senderName: 'Anda',
      isMine: true,
      type: ChatMessageType.image,
      imageUrl: url,
      sentAt: DateTime.now(),
    );

    _appendMessage(threadId: threadId, message: outgoing);
    _socketService.simulateReply(threadId: threadId, fromMessage: 'foto');
  }

  void _onSocketEvent(ChatSocketEvent event) {
    _appendMessage(threadId: event.threadId, message: event.message);
  }

  void _appendMessage({
    required String threadId,
    required ChatMessage message,
  }) {
    final nextMap = {...state.messagesByThread};
    final messages = [...state.messagesFor(threadId), message]
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    nextMap[threadId] = messages;

    final isActive = state.activeThreadId == threadId;
    final threads = state.threads.map((thread) {
      if (thread.id != threadId) return thread;
      final nextUnread = message.isMine
          ? 0
          : (isActive ? 0 : thread.unreadCount + 1);
      return thread.copyWith(
        lastMessage: message.previewText,
        lastMessageAt: message.sentAt,
        unreadCount: nextUnread,
      );
    }).toList()..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

    emit(
      state.copyWith(
        messagesByThread: nextMap,
        threads: threads,
        clearError: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _socketSub?.cancel();
    await _socketService.dispose();
    return super.close();
  }
}
