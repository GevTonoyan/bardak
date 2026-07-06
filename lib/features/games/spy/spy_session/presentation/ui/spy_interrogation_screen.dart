import 'dart:async';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The questioning phase: a big countdown the whole table can watch while
/// players take turns asking questions to find the spy.
class SpyInterrogationScreen extends StatefulWidget {
  const SpyInterrogationScreen({super.key});

  static const routePath = 'spyInterrogation';

  @override
  State<SpyInterrogationScreen> createState() => _SpyInterrogationScreenState();
}

class _SpyInterrogationScreenState extends State<SpyInterrogationScreen> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = context
        .read<SpySessionBloc>()
        .state
        .session
        .roundDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _finishGame();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finishGame() {
    final session = context.read<SpySessionBloc>().state.session;
    context.goNamed(SpyResultScreen.routePath, extra: session);
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    final timerColor = switch (_remainingSeconds) {
      <= 15 => colors.red,
      <= 60 => colors.orange,
      _ => colors.green,
    };

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: typography.displayLarge.withNumericFont.copyWith(
                        color: timerColor,
                      ),
                    ),
                    height30,
                    Padding(
                      padding: const .symmetric(horizontal: 40),
                      child: Text(
                        l10n.spy_find_the_spy,
                        textAlign: .center,
                        style: typography.regular18.copyWith(
                          color: colors.white50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ShadowBackground(
                child: Padding(
                  padding: const .all(20),
                  child: AppButton(
                    label: l10n.spy_finish_game,
                    color: colors.red,
                    onPressed: _finishGame,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
