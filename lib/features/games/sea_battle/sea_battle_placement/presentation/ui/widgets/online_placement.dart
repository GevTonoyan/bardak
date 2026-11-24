import 'dart:async';
import 'dart:ui';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_error_view.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/app_waiting_dots.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_game_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Asks before leaving the room, which ends the game for both players.
Future<void> showLeaveRoomSheet(BuildContext context) async {
  await showExitGameSheet(
    context: context,
    onConfirm: () =>
        context.read<SeaBattleOnlinePlacementBloc>().add(const LeaveRoom()),
  );
}

/// Online placement around [child]: covers the screen while waiting for
/// the other player, moves on to the battle once the host starts it, and
/// asks before leaving the room.
class OnlinePlacement extends StatelessWidget {
  const OnlinePlacement({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<
          SeaBattleOnlinePlacementBloc,
          SeaBattleOnlinePlacementState
        >(
          listenWhen: (previous, current) =>
              current is SeaBattleOnlinePlacementStarted,
          // The battle replaces placement, like against the bot.
          listener: (context, state) {
            final started = state as SeaBattleOnlinePlacementStarted;
            context.pushReplacementNamed(
              SeaBattleGameScreen.routePath,
              extra: SeaBattleGameArgs(
                playerFleet: started.fleet,
                room: started.room,
              ),
            );
          },
        ),
        BlocListener<
          SeaBattleOnlinePlacementBloc,
          SeaBattleOnlinePlacementState
        >(
          listenWhen: (previous, current) =>
              current is SeaBattleOnlinePlacementClosed,
          listener: (context, state) {
            unawaited(
              showAppNotification(
                context,
                message: context.l10n.sea_battle_room_closed,
              ),
            );
            context.pop();
          },
        ),
        BlocListener<
          SeaBattleOnlinePlacementBloc,
          SeaBattleOnlinePlacementState
        >(
          listenWhen: (previous, current) =>
              current is SeaBattleOnlinePlacementLeft,
          listener: (context, state) => context.pop(),
        ),
      ],
      // The system back gesture asks too, like the back button.
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(showLeaveRoomSheet(context));
        },
        child: Stack(
          children: [
            child,
            const Positioned.fill(child: _ReadyOverlay()),
          ],
        ),
      ),
    );
  }
}

/// Blurs and dims the board once the player is ready, with a card saying
/// they are waiting for the other player, or a retry when telling the
/// room failed.
class _ReadyOverlay extends StatelessWidget {
  const _ReadyOverlay();

  static const _blur = 6.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = context.watch<SeaBattleOnlinePlacementBloc>().state;

    final content = switch (state) {
      SeaBattleOnlinePlacementWaiting() ||
      SeaBattleOnlinePlacementStarted() => const _ReadyCard(),
      SeaBattleOnlinePlacementFailure(:final fleet) => _ReadyFailureCard(
        onRetry: () =>
            context.read<SeaBattleOnlinePlacementBloc>().add(MarkReady(fleet)),
      ),
      _ => null,
    };

    // Above the screen's own Material, so it brings its own for the text.
    return Material(
      type: .transparency,
      child: IgnorePointer(
        ignoring: content == null,
        child: AnimatedOpacity(
          opacity: content == null ? 0 : 1,
          duration: const Duration(milliseconds: 250),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
            child: ColoredBox(
              color: colors.black.withValues(alpha: 0.45),
              child: Center(
                child: Padding(
                  padding: const .symmetric(horizontal: 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: content,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The dark rounded card the ready overlay shows its message on.
class _OverlayCard extends StatelessWidget {
  const _OverlayCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const .fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: .circular(24),
        border: .all(color: colors.white30, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// "You're ready!" with a green check, waiting for the other player, and
/// a way out if they take too long.
class _ReadyCard extends StatelessWidget {
  const _ReadyCard();

  static const _badgeSize = 64.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    return _OverlayCard(
      child: Column(
        mainAxisSize: .min,
        children: [
          Container(
            width: _badgeSize,
            height: _badgeSize,
            decoration: BoxDecoration(
              color: colors.green,
              shape: .circle,
              border: .all(color: colors.white, width: 3),
            ),
            child: Icon(Icons.check_rounded, size: 38, color: colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.sea_battle_you_are_ready,
            textAlign: .center,
            style: typography.regular28,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.sea_battle_waiting_for_opponent_ships,
            textAlign: .center,
            style: typography.bodyMedium.copyWith(color: colors.white50),
          ),
          const SizedBox(height: 28),
          const AppWaitingDots(),
          const SizedBox(height: 28),
          AppButton(
            label: l10n.sea_battle_leave,
            color: colors.white20,
            size: .small,
            onPressed: () => unawaited(showLeaveRoomSheet(context)),
          ),
        ],
      ),
    );
  }
}

/// Telling the room the player is ready failed, with Retry.
class _ReadyFailureCard extends StatelessWidget {
  const _ReadyFailureCard({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _OverlayCard(
      child: AppErrorView(
        icon: Icons.wifi_off_rounded,
        message: context.l10n.sea_battle_connection_error,
        actionLabel: context.l10n.retry,
        actionColor: context.colors.green,
        onAction: onRetry,
      ),
    );
  }
}
