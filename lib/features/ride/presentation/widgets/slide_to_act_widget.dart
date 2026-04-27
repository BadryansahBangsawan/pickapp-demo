import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SlideToActWidget extends StatelessWidget {
  const SlideToActWidget({
    super.key,
    required this.label,
    required this.onSubmitted,
  });

  final String label;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Builder(
      builder: (context) {
        final GlobalKey<SlideActionState> key = GlobalKey();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SlideAction(
            text: label,
            textColor: theme.textTheme.labelLarge?.color ?? Colors.black,
            innerColor: theme.colorScheme.onPrimary,
            outerColor: theme.colorScheme.primary,
            sliderButtonIcon: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            key: key,
            onSubmit: () {
              onSubmitted();
              Future.delayed(
                const Duration(seconds: 1),
                () => key.currentState?.reset(),
              );
              return null;
            },
          ),
        );
      },
    );
  }
}
