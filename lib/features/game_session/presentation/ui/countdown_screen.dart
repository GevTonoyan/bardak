import 'dart:async';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  int _count = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _startCountdown();
  }

  void _startCountdown() {
    _controller.forward();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 0) {
        setState(() => _count--);
        _controller
          ..reset()
          ..forward();
      } else {
        timer.cancel();
        _handleCountdownFinished();
      }
    });
  }

  void _handleCountdownFinished() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        //context.pushNamed(RouteNames.gameplay);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  _count > 0 ? '$_count' : context.l10n.alias_countdown_go,
                  style: TextStyle(
                    fontSize: _count > 0 ? 120 : 50,
                    fontWeight: FontWeight.bold,
                    color: _count > 0 ? colors.primary : colors.success,
                    shadows: [Shadow(blurRadius: 10, color: colors.shadow)],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
