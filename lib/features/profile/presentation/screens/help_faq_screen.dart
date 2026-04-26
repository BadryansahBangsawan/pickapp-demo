import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/pickup_app_bar.dart';
import '../../../../core/widgets/pickup_empty_state.dart';
import '../bloc/profile_cubit.dart';
import '../models/profile_models.dart';

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PickupAppBar(title: 'Bantuan & FAQ', bottomBorder: true),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final items = _filterFaq(state.faqs, _query);
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => setState(() => _query = value),
                    decoration: const InputDecoration(
                      hintText: 'Cari pertanyaan',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Expanded(
                    child: items.isEmpty
                        ? const PickupEmptyState(
                            title: 'FAQ tidak ditemukan',
                            message:
                                'Coba kata kunci lain atau hubungi support melalui tab chat.',
                            icon: Icons.help_outline,
                          )
                        : ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final faq = items[index];
                              return ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.base,
                                ),
                                title: Text(
                                  faq.question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                childrenPadding: const EdgeInsets.fromLTRB(
                                  AppSpacing.base,
                                  0,
                                  AppSpacing.base,
                                  AppSpacing.base,
                                ),
                                children: [
                                  Text(
                                    faq.answer,
                                    style: const TextStyle(height: 1.4),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<FaqItem> _filterFaq(List<FaqItem> input, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return input;

    return input
        .where(
          (item) =>
              item.question.toLowerCase().contains(q) ||
              item.answer.toLowerCase().contains(q),
        )
        .toList();
  }
}
