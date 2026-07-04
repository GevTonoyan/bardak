import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const routePath = '/splash';
  static const heroTag = 'app-logo-hero';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller
      ..forward()
      ..addStatusListener((status) {
        if (status == .completed) {
          context.goNamed(HomeScreen.routePath);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Hero(
            tag: SplashScreen.heroTag,
            child: Assets.images.logo.image(
              height: 220,
              width: 220,
              fit: .contain,
            ),
          ),
        ),
      ),
    );
  }
}
