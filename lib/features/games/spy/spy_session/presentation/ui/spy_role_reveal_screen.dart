import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/flip_card.dart';
import 'package:bardak/core/app_ui/widgets/game_card.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_event.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_state.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_interrogation_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Delay before advancing to the next player, matched to [FlipCard]'s default
/// flip duration so the card finishes flipping face-down first.
const _flipDuration = Duration(milliseconds: 450);

/// Pass-the-phone screen where every player peeks at their role card.
///
/// The card is the only control: tap to reveal, tap again to hide and hand
/// the phone on. Once everyone has looked, a single "start" action begins
/// the round.
class SpyRoleRevealScreen extends StatefulWidget {
  const SpyRoleRevealScreen({super.key});

  static const routePath = 'spyRoleReveal';

  @override
  State<SpyRoleRevealScreen> createState() => _SpyRoleRevealScreenState();
}

class _SpyRoleRevealScreenState extends State<SpyRoleRevealScreen> {
  var _isRevealed = false;
  var _isFlippingBack = false;

  void _onCardTap() {
    // Ignore taps while the card is flipping back to the next player.
    if (_isFlippingBack) return;

    if (_isRevealed) {
      // Flip the card face-down first, then advance once the flip finishes so
      // the hand-off shows the same flip animation as the reveal.
      setState(() {
        _isRevealed = false;
        _isFlippingBack = true;
      });
      Future<void>.delayed(_flipDuration, () {
        if (!mounted) return;
        context.read<SpySessionBloc>().add(const FinishPlayerReveal());
        setState(() => _isFlippingBack = false);
      });
    } else {
      setState(() => _isRevealed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const .only(left: 20, top: 20, right: 20),
              child: Row(
                children: [
                  AppIconButton.close(
                    onTap: () async {
                      await showConfirmSheet(
                        context: context,
                        title: l10n.exit_game_title,
                        description: l10n.exit_game_description,
                        confirmText: l10n.exit_game_confirm,
                        cancelText: l10n.cancel,
                        confirmColor: colors.red,
                        cancelColor: colors.green,
                        onConfirm: () => context.goNamed(HomeScreen.routePath),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SpySessionBloc, SpySessionState>(
                builder: (context, state) {
                  final session = state.session;

                  if (session.isRevealCompleted) {
                    return const _StartRoundView();
                  }

                  return _RevealView(
                    session: session,
                    isRevealed: _isRevealed,
                    onCardTap: _onCardTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevealView extends StatelessWidget {
  const _RevealView({
    required this.session,
    required this.isRevealed,
    required this.onCardTap,
  });

  final SpySessionEntity session;
  final bool isRevealed;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.typography;
    final colors = context.colors;

    return Column(
      children: [
        SmartNumberText(
          l10n.player_with_number(session.currentRevealPlayer.number),
          style: typography.regular28,
        ),
        height20,
        // Fixed height reserves room for a two-line hint so the card below
        // never shifts when the text changes between reveal and hide.
        SizedBox(
          height: 56,
          child: Padding(
            padding: const .symmetric(horizontal: 40),
            child: Align(
              alignment: .topCenter,
              child: Text(
                isRevealed ? l10n.spy_tap_to_hide : l10n.spy_tap_to_reveal,
                textAlign: .center,
                maxLines: 2,
                overflow: .ellipsis,
                style: typography.regular18.copyWith(color: colors.white50),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: onCardTap,
              // Keyed by player so the card is recreated face-down and the
              // next player's role never flashes mid-flip.
              child: FlipCard(
                key: ValueKey(session.currentRevealIndex),
                isFlipped: isRevealed,
                front: const GameCardBack(),
                back: _RoleCard(session: session),
              ),
            ),
          ),
        ),
        height40,
      ],
    );
  }
}

class _StartRoundView extends StatelessWidget {
  const _StartRoundView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              l10n.spy_all_ready,
              textAlign: .center,
              style: context.typography.regular28,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ShadowBackground(
            child: Padding(
              padding: const .all(20),
              child: AppButton(
                label: l10n.spy_start_game,
                color: context.colors.green,
                onPressed: () => context.pushReplacementNamed(
                  SpyInterrogationScreen.routePath,
                ),
              ),
            ),
          ),
        ),
      ],
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
            : Text(
                session.secretWord,
                textAlign: .center,
                style: typography.regular28,
              ),
      ),
    );
  }
}
