import 'package:flutter/material.dart';

@immutable
class ChatThread {
  const ChatThread({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unreadCount,
    required this.isOnline,
  });

  final String id;
  final String name;
  final String subtitle;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageAt;
  final int unreadCount;
  final bool isOnline;

  ChatThread copyWith({
    String? subtitle,
    String? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatThread(
      id: id,
      name: name,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

enum ChatMessageType { text, image }

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.threadId,
    required this.senderName,
    required this.isMine,
    required this.type,
    this.text,
    this.imageUrl,
    required this.sentAt,
  });

  final String id;
  final String threadId;
  final String senderName;
  final bool isMine;
  final ChatMessageType type;
  final String? text;
  final String? imageUrl;
  final DateTime sentAt;

  String get previewText {
    if (type == ChatMessageType.image) {
      return isMine ? 'Anda mengirim foto' : '$senderName mengirim foto';
    }
    return text ?? '';
  }
}

List<ChatThread> buildMockChatThreads() {
  final now = DateTime.now();
  return [
    ChatThread(
      id: 'driver-rizky',
      name: 'Rizky (Driver PickRide)',
      subtitle: 'Honda Beat • B 1234 PIK',
      avatarUrl: 'https://i.pravatar.cc/240?img=12',
      lastMessage: 'Saya sudah di depan lobby ya kak.',
      lastMessageAt: now.subtract(const Duration(minutes: 2)),
      unreadCount: 1,
      isOnline: true,
    ),
    ChatThread(
      id: 'food-warung-bu-tini',
      name: 'Warung Bu Tini',
      subtitle: 'Pesanan PickFood',
      avatarUrl: 'https://picsum.photos/seed/warung-bu-tini/200/200',
      lastMessage: 'Pesanan sedang disiapkan, estimasi 12 menit.',
      lastMessageAt: now.subtract(const Duration(minutes: 16)),
      unreadCount: 0,
      isOnline: true,
    ),
    ChatThread(
      id: 'support',
      name: 'Bantuan Pick Up',
      subtitle: 'Customer support',
      avatarUrl: 'https://i.pravatar.cc/240?img=32',
      lastMessage: 'Ada yang bisa kami bantu lagi?',
      lastMessageAt: now.subtract(const Duration(hours: 3)),
      unreadCount: 0,
      isOnline: false,
    ),
  ];
}

List<ChatMessage> initialMessagesForThread(String threadId) {
  final now = DateTime.now();

  if (threadId == 'driver-rizky') {
    return [
      ChatMessage(
        id: 'm-1',
        threadId: threadId,
        senderName: 'Rizky',
        isMine: false,
        type: ChatMessageType.text,
        text: 'Halo kak, saya driver yang ambil ordernya.',
        sentAt: now.subtract(const Duration(minutes: 9)),
      ),
      ChatMessage(
        id: 'm-2',
        threadId: threadId,
        senderName: 'Anda',
        isMine: true,
        type: ChatMessageType.text,
        text: 'Baik mas, saya tunggu di lobby.',
        sentAt: now.subtract(const Duration(minutes: 7)),
      ),
      ChatMessage(
        id: 'm-3',
        threadId: threadId,
        senderName: 'Rizky',
        isMine: false,
        type: ChatMessageType.text,
        text: 'Saya sudah di depan lobby ya kak.',
        sentAt: now.subtract(const Duration(minutes: 2)),
      ),
    ];
  }

  if (threadId == 'food-warung-bu-tini') {
    return [
      ChatMessage(
        id: 'f-1',
        threadId: threadId,
        senderName: 'Warung Bu Tini',
        isMine: false,
        type: ChatMessageType.text,
        text: 'Terima kasih sudah order di Warung Bu Tini.',
        sentAt: now.subtract(const Duration(minutes: 24)),
      ),
      ChatMessage(
        id: 'f-2',
        threadId: threadId,
        senderName: 'Anda',
        isMine: true,
        type: ChatMessageType.text,
        text: 'Tolong sambalnya dipisah ya.',
        sentAt: now.subtract(const Duration(minutes: 19)),
      ),
      ChatMessage(
        id: 'f-3',
        threadId: threadId,
        senderName: 'Warung Bu Tini',
        isMine: false,
        type: ChatMessageType.text,
        text: 'Pesanan sedang disiapkan, estimasi 12 menit.',
        sentAt: now.subtract(const Duration(minutes: 16)),
      ),
    ];
  }

  return [
    ChatMessage(
      id: 's-1',
      threadId: threadId,
      senderName: 'Support',
      isMine: false,
      type: ChatMessageType.text,
      text: 'Halo! Kami siap bantu kapan saja.',
      sentAt: now.subtract(const Duration(hours: 3, minutes: 2)),
    ),
    ChatMessage(
      id: 's-2',
      threadId: threadId,
      senderName: 'Support',
      isMine: false,
      type: ChatMessageType.text,
      text: 'Ada yang bisa kami bantu lagi?',
      sentAt: now.subtract(const Duration(hours: 3)),
    ),
  ];
}

const chatQuickReplies = <String>[
  'Oke, terima kasih',
  'Saya sudah di lokasi',
  'Mohon tunggu 2 menit',
  'Bisa kirim update posisi?',
];

const chatDummyImageUrls = <String>[
  'https://picsum.photos/seed/chat-image-1/1200/900',
  'https://picsum.photos/seed/chat-image-2/1200/900',
  'https://picsum.photos/seed/chat-image-3/1200/900',
  'https://picsum.photos/seed/chat-image-4/1200/900',
];
