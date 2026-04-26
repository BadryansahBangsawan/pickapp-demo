import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PickupAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PickupAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.showBack = true,
    this.bottom,
    this.bottomBorder = false,
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBack;
  final PreferredSizeWidget? bottom;
  final bool bottomBorder;

  @override
  Size get preferredSize {
    final extra = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + extra + (bottomBorder ? 1 : 0));
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return AppBar(
      title: title == null ? null : Text(title!),
      leading:
          leading ??
          (showBack && canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      bottom:
          bottom ??
          (bottomBorder
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(1),
                  child: Divider(height: 1, color: AppColors.divider),
                )
              : null),
    );
  }
}
