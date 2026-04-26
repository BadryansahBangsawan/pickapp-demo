import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../bloc/chat_cubit.dart';
import '../models/chat_models.dart';
import '../widgets/message_bubble.dart';
import '../widgets/quick_reply_chips.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.thread});

  final ChatThread thread;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().openThread(widget.thread.id);
    });
  }

  @override
  void dispose() {
    context.read<ChatCubit>().closeActiveThread();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text;
    context.read<ChatCubit>().sendTextMessage(widget.thread.id, text);
    _controller.clear();
  }

  void _sendQuickReply(String text) {
    context.read<ChatCubit>().sendQuickReply(widget.thread.id, text);
  }

  void _sendDummyImage() {
    context.read<ChatCubit>().sendDummyImage(widget.thread.id);
  }

  void _autoScrollIfNeeded(int count) {
    if (count == 0 || count == _lastMessageCount) return;
    _lastMessageCount = count;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PickupAppBar(
        title: widget.thread.name,
        bottomBorder: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.base),
            child: Icon(
              widget.thread.isOnline ? Icons.circle : Icons.circle_outlined,
              size: 12,
              color: widget.thread.isOnline
                  ? AppColors.success
                  : AppColors.textHint,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  final messages = state.messagesFor(widget.thread.id);
                  _autoScrollIfNeeded(messages.length);

                  if (messages.isEmpty) {
                    return const PickupEmptyState(
                      title: 'Belum ada pesan',
                      message:
                          'Mulai percakapan untuk menghubungi driver atau merchant.',
                      icon: Icons.mark_chat_unread_outlined,
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.base,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: messages[index]);
                    },
                  );
                },
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.divider)),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.sm,
                AppSpacing.base,
                AppSpacing.base,
              ),
              child: Column(
                children: [
                  QuickReplyChips(
                    replies: chatQuickReplies,
                    onTap: _sendQuickReply,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      SizedBox(
                        width: AppTouchTarget.minimum,
                        height: AppTouchTarget.minimum,
                        child: IconButton(
                          onPressed: _sendDummyImage,
                          icon: const Icon(Icons.image_outlined),
                          tooltip: 'Kirim gambar dummy',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText: 'Tulis pesan...',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      SizedBox(
                        width: AppTouchTarget.minimum,
                        height: AppTouchTarget.minimum,
                        child: IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send_rounded),
                          color: AppColors.primary,
                          tooltip: 'Kirim',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
