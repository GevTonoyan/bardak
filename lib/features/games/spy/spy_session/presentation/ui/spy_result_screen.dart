import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/highlighted_text.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_packs_screen.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_role_reveal_screen.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/ui/spy_settings_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// End-of-round screen revealing the spies and the secret word.
class SpyResultScreen extends StatelessWidget {
  const SpyResultScreen({required this.session, super.key});

  static const routePath = 'spyResult';

  final SpySessionEntity session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    final spies = session.spies;
    final spyNames = spies
        .map((spy) => l10n.player_with_number(spy.number))
        .join(', ');

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
                        l10n.spy_reveal_spies(spies.length),
                        textAlign: .center,
                        style: typography.regular24,
                      ),
                      height20,
                      HighlightedText(text: spyNames),
                      height40,
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
              // bottom safe-area inset, on top of the 260px of buttons.
              SizedBox(
                height: 360,
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
                        AppButton(
                          label: l10n.change_pack,
                          color: colors.white20,
                          onPressed: () => context.pushReplacementNamed(
                            SpyPacksScreen.routePath,
                          ),
                        ),
                        height20,
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
