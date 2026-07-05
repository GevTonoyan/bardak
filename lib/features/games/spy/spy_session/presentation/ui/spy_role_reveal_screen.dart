import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/flip_card.dart';
import 'package:bardak/core/app_ui/widgets/game_card.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_event.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_state.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_interrogation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Pass-the-phone screen where every player peeks at their role card.
class SpyRoleRevealScreen extends StatefulWidget {
  const SpyRoleRevealScreen({super.key});

  static const routePath = 'spyRoleReveal';

  @override
  State<SpyRoleRevealScreen> createState() => _SpyRoleRevealScreenState();
}

class _SpyRoleRevealScreenState extends State<SpyRoleRevealScreen> {
  var _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.typography;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: BlocConsumer<SpySessionBloc, SpySessionState>(
          listenWhen: (previous, current) =>
              !previous.session.isRevealCompleted &&
              current.session.isRevealCompleted,
          listener: (context, state) {
            context.pushReplacementNamed(SpyInterrogationScreen.routePath);
          },
          builder: (context, state) {
            final session = state.session;
            if (session.isRevealCompleted) return const SizedBox.shrink();

            final player = session.currentRevealPlayer;

            return Column(
              children: [
                height40,
                SmartNumberText(
                  l10n.player_with_number(player.number),
                  style: typography.regular28,
                ),
                height20,
                Text(
                  _isRevealed ? '' : l10n.spy_tap_to_reveal,
                  style: typography.regular18.copyWith(
                    color: context.colors.white50,
                  ),
                ),
                Expanded(
                  child: Center(
                    // Keyed by player so the card is recreated unflipped
                    // and the next player's role never flashes mid-flip.
                    child: FlipCard(
                      key: ValueKey(session.currentRevealIndex),
                      isFlipped: _isRevealed,
                      front: GameCardBack(
                        onTap: () => setState(() => _isRevealed = true),
                      ),
                      back: _RoleCard(session: session),
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ShadowBackground(
                    child: Padding(
                      padding: const .all(20),
                      child: AppButton(
                        label: l10n.spy_pass_phone,
                        color: context.colors.green,
                        onPressed: _isRevealed
                            ? () {
                                setState(() => _isRevealed = false);
                                context.read<SpySessionBloc>().add(
                                  const FinishPlayerReveal(),
                                );
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.session});

  final SpySessionEntity session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    final isSpy = session.currentRevealPlayer.isSpy;

    return GameCardShell(
      child: Center(
        child: isSpy
            ? Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    l10n.spy_you_are_spy,
                    textAlign: .center,
                    style: typography.regular28,
                  ),
                  height20,
                  Padding(
                    padding: const .symmetric(horizontal: 10),
                    child: Text(
                      l10n.spy_dont_reveal,
                      textAlign: .center,
                      style: typography.regular18.copyWith(
                        color: colors.white50,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: .min,
                children: [
                  Text(
                    l10n.spy_secret_word,
                    textAlign: .center,
                    style: typography.regular18.copyWith(
                      color: colors.white50,
                    ),
                  ),
                  height20,
                  Text(
                    session.secretWord,
                    textAlign: .center,
                    style: typography.regular28,
                  ),
                ],
              ),
      ),
    );
  }
}
