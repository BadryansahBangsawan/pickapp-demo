import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class PromoSlide {
  const PromoSlide({
    required this.title,
    required this.subtitle,
    required this.color,
  });
  final String title;
  final String subtitle;
  final Color color;
}

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key, required this.slides});
  final List<PromoSlide> slides;

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final _controller = PageController();
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || widget.slides.isEmpty) return;
      _index = (_index + 1) % widget.slides.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: widget.slides.length,
            itemBuilder: (context, i) => _PromoCard(slide: widget.slides[i]),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.slides.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.borderLight,
          ),
        ),
      ],
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.slide});
  final PromoSlide slide;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: slide.color,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slide.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  slide.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Colors.white.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
