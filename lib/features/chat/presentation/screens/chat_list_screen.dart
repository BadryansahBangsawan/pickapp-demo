import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../../../../core/widgets/pickup_error_state.dart';
import '../../../../core/widgets/pickup_shimmer.dart';
import '../bloc/chat_cubit.dart';
import '../models/chat_models.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String _query = '';

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ChatCubit>();
    if (cubit.state.threads.isEmpty) {
      cubit.loadThreads(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Chat', bottomBorder: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.base,
            AppSpacing.base,
            0,
          ),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: 'Cari chat driver, restoran, atau bantuan',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state.isLoading && state.threads.isEmpty) {
                      return const _ChatListLoading();
                    }

                    if (state.hasError && state.threads.isEmpty) {
                      return PickupErrorState.auto(
                        title: 'Chat tidak dapat dimuat',
                        message: state.errorMessage!,
                        onRetry: () =>
                            context.read<ChatCubit>().loadThreads(force: true),
                      );
                    }

                    final threads = _filterThreads(state.threads, _query);
                    if (threads.isEmpty) {
                      return PickupEmptyState(
                        title: 'Belum ada chat',
                        message: _query.trim().isEmpty
                            ? 'Percakapan dengan driver, restoran, dan support akan muncul di sini.'
                            : 'Tidak ada hasil untuk "${_query.trim()}".',
                        icon: Icons.chat_bubble_outline,
                        actionLabel: _query.trim().isEmpty
                            ? null
                            : 'Reset Pencarian',
                        onAction: _query.trim().isEmpty
                            ? null
                            : () => setState(() => _query = ''),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<ChatCubit>().refreshThreads(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: threads.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final thread = threads[index];
                          return _ChatTile(
                            thread: thread,
                            onTap: () => context.push(
                              RouteNames.chatRoom,
                              extra: thread,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ChatThread> _filterThreads(List<ChatThread> input, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return input;
    return input.where((thread) {
      return thread.name.toLowerCase().contains(q) ||
          thread.subtitle.toLowerCase().contains(q) ||
          thread.lastMessage.toLowerCase().contains(q);
    }).toList();
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.thread, required this.onTap});

  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      minVerticalPadding: 0,
      onTap: onTap,
      leading: SizedBox(
        width: 52,
        height: 52,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Image.network(
                thread.avatarUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 52,
                  height: 52,
                  color: AppColors.surface,
                  alignment: Alignment.center,
                  child: const Icon(Icons.person_outline),
                ),
              ),
            ),
            if (thread.isOnline)
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
      title: Text(
        thread.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          thread.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            height: 1.3,
          ),
        ),
      ),
      trailing: SizedBox(
        width: 56,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Formatters.relative(thread.lastMessageAt),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (thread.unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '${thread.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChatListLoading extends StatelessWidget {
  const _ChatListLoading();

  @override
  Widget build(BuildContext context) {
    return PickupListShimmer(
      itemBuilder: (context, index) {
        return Row(
          children: [
            const PickupShimmerBox(
              height: 52,
              width: 52,
              radius: AppRadius.full,
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PickupShimmerBox(height: 14, width: 150),
                  SizedBox(height: AppSpacing.sm),
                  PickupShimmerBox(height: 12, width: double.infinity),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
