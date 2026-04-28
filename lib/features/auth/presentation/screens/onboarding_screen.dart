import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/pickup_button.dart';

class _OnboardSlide {
  const _OnboardSlide(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

const _slides = <_OnboardSlide>[
  _OnboardSlide(
    Icons.two_wheeler_outlined,
    'Pesan Ride Kapanpun',
    'Motor & mobil siap menjemput dimanapun, kapanpun.',
  ),
  _OnboardSlide(
    Icons.local_shipping_outlined,
    'Kirim Barang Mudah',
    'Antar paket aman dan cepat, sampai ke tangan tujuan.',
  ),
  _OnboardSlide(
    Icons.restaurant_outlined,
    'Pesan Makanan Favorit',
    'Restoran terdekat tersedia, langsung sampai ke rumah.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _slides.length - 1) {
      context.go(RouteNames.login);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(RouteNames.login),
                child: const Text('Lewati'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _index = i),
                itemCount: _slides.length,
                itemBuilder: (context, i) => _OnboardingPage(slide: _slides[i]),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _slides.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.borderLight,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              child: PickupButton(
                label: _index == _slides.length - 1 ? 'Mulai' : 'Lanjut',
                onPressed: _next,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.slide});
  final _OnboardSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(slide.icon, size: 96, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            slide.title,
            style: AppTypography.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            slide.subtitle,
            style: AppTypography.caption.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
