import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/highlighted_text.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_role_reveal_screen.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/ui/spy_settings_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// End-of-round screen revealing the secret word.
class SpyResultScreen extends StatelessWidget {
  const SpyResultScreen({required this.session, super.key});

  static const routePath = 'spyResult';

  final SpySessionEntity session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    return BlocListener<SpyPacksBloc, SpyPacksState>(
      listenWhen: (previous, current) => current is SpyGameReady,
      listener: (context, state) {
        if (state is! SpyGameReady) return;
        context.goNamed(SpyRoleRevealScreen.routePath, extra: state.session);
      },
      child: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const .only(left: 20, top: 20, right: 20),
                child: Row(
                  children: [
                    AppIconButton.close(
                      onTap: () => context.goNamed(HomeScreen.routePath),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        l10n.spy_secret_word,
                        textAlign: .center,
                        style: typography.regular18.copyWith(
                          color: colors.white50,
                        ),
                      ),
                      height20,
                      HighlightedText(text: session.secretWord),
                    ],
                  ),
                ),
              ),
              // ShadowBackground consumes 60px for its jagged edge plus the
              // bottom safe-area inset, on top of the 180px of buttons.
              SizedBox(
                height: 280,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: Column(
                      children: [
                        AppButton(
                          label: l10n.play_again,
                          color: colors.green,
                          onPressed: () => context.read<SpyPacksBloc>().add(
                            StartSpyGame(
                              pack: session.pack,
                              locale: context.locale.languageCode,
                            ),
                          ),
                        ),
                        height20,
                        // Settings flows back into pack selection via its
                        // Proceed button, so one entry covers both.
                        AppButton(
                          label: l10n.settings,
                          color: colors.white20,
                          onPressed: () => context.pushReplacementNamed(
                            SpySettingsScreen.routePath,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
