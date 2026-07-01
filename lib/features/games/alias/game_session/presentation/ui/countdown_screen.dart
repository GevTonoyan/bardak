import 'dart:async';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/state_extension.dart';
import 'package:bardak/features/games/alias/card_round/presentation/ui/card_round_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  static const routePath = 'countdown';

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    unawaited(_startCountdown());
  }

  Future<void> _startCountdown() async {
    _controller
      ..reset()
      ..forward();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count > 1) {
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
    final gameSessionBloc = context.read<GameSessionBloc>();
    final gameMode = gameSessionBloc.state.gameState.gameMode;

    final path = switch (gameMode) {
      .card => CardRoundScreen.routePath,
      .singleWord => SingleWordRoundScreen.routePath,
    };
    context.pushReplacementNamed(path);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) {
                  final scale = Tween<double>(
                    begin: 0.95,
                    end: 1,
                  ).animate(anim);
                  return FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(scale: scale, child: child),
                  );
                },
                child: Text(
                  '$_count',
                  key: ValueKey(_count),
                  style: typography.countdownNumber.withNumericFont,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
