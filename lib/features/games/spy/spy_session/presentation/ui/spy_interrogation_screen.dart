import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/round_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_result_screen.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The questioning phase: players take turns asking questions to find the
/// spy while the round timer counts down in the header.
class SpyInterrogationScreen extends StatelessWidget {
  const SpyInterrogationScreen({super.key});

  static const routePath = 'spyInterrogation';

  void _finishGame(BuildContext context) {
    final session = context.read<SpySessionBloc>().state.session;
    context.goNamed(SpyResultScreen.routePath, extra: session);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    final session = context.read<SpySessionBloc>().state.session;
    final soundEnabled = context
        .read<SettingsBloc>()
        .state
        .appSettings
        .soundEnabled;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            RoundHeader(
              initialRoundDuration: session.roundDuration,
              isSoundEnabled: soundEnabled,
              onRoundComplete: () => _finishGame(context),
              onPauseChanged: (_) {},
              formatTimerAsMinutes: true,
              // Spy rounds run for minutes, so warn earlier than alias.
              timerOrangeBelow: 60,
              timerRedBelow: 15,
              stopDescription: l10n.spy_round_stop_description,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const .symmetric(horizontal: 40),
                  child: Text(
                    l10n.spy_find_the_spy,
                    textAlign: .center,
                    style: typography.regular24.copyWith(
                      color: colors.white50,
                    ),
                  ),
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
                    onPressed: () => _finishGame(context),
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
