import 'dart:async';
import 'dart:math';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_error_view.dart';
import 'package:bardak/core/app_ui/widgets/app_icon.dart';
import 'package:bardak/core/app_ui/widgets/app_input_field.dart';
import 'package:bardak/core/app_ui/widgets/app_loader.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/app_screen_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

/// The host's screen for inviting a friend: creates the room, then shows
/// its invite link as a QR code to scan, a link to copy and Share. Moves on
/// to placement once the friend joins.
class SeaBattleWaitingRoomScreen extends StatelessWidget {
  const SeaBattleWaitingRoomScreen({super.key});

  static const routePath = 'seaBattleWaitingRoom';

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
          listenWhen: (previous, current) =>
              current is SeaBattleWaitingRoomWaiting &&
              current.room.hasOpponent &&
              !(previous is SeaBattleWaitingRoomWaiting &&
                  previous.room.hasOpponent),
          listener: (context, state) => context.pushReplacementNamed(
            SeaBattlePlacementScreen.routePath,
            extra: SeaBattlePlacementArgs(
              mode: .online,
              room: (state as SeaBattleWaitingRoomWaiting).room,
            ),
          ),
        ),
        BlocListener<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
          listenWhen: (previous, current) =>
              current is SeaBattleWaitingRoomClosed ||
              current is SeaBattleWaitingRoomLeft,
          listener: (context, state) {
            if (state is SeaBattleWaitingRoomClosed) {
              unawaited(
                showAppNotification(
                  context,
                  message: context.l10n.sea_battle_room_closed,
                ),
              );
            }
            context.pop();
          },
        ),
      ],
      // Going back leaves the room, which closes it.
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _leave(context);
        },
        child: GradientBackground(
          child: SafeArea(
            child: Padding(
              padding: const .fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  AppScreenHeader(
                    title: context.l10n.sea_battle_invite_title,
                    onBack: () => _leave(context),
                  ),
                  const Expanded(child: _WaitingRoomBody()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _leave(BuildContext context) =>
    context.read<SeaBattleWaitingRoomBloc>().add(const LeaveRoom());

/// A spinner while the room is made, a retry if that fails, and the invite
/// once it is open.
class _WaitingRoomBody extends StatelessWidget {
  const _WaitingRoomBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
      // Updates to an open room only matter if its link changes, and the
      // closing states leave the last screen up while it goes.
      buildWhen: (previous, current) => switch ((previous, current)) {
        (
          SeaBattleWaitingRoomWaiting(room: final before),
          SeaBattleWaitingRoomWaiting(room: final after),
        ) =>
          before.code != after.code,
        (
          _,
          SeaBattleWaitingRoomLeaving() ||
              SeaBattleWaitingRoomClosed() ||
              SeaBattleWaitingRoomLeft(),
        ) =>
          false,
        _ => true,
      },
      builder: (context, state) => Center(
        child: SingleChildScrollView(
          padding: const .symmetric(vertical: 24),
          child: switch (state) {
            SeaBattleWaitingRoomWaiting(:final room) => _Invite(
              link: room.inviteLink,
            ),
            SeaBattleWaitingRoomFailure() => AppErrorView(
              icon: Icons.wifi_off_rounded,
              message: context.l10n.sea_battle_connection_error,
              actionLabel: context.l10n.retry,
              actionColor: context.colors.green,
              onAction: () => context.read<SeaBattleWaitingRoomBloc>().add(
                const CreateRoom(),
              ),
            ),
            _ => AppLoader(label: context.l10n.sea_battle_creating_room),
          },
        ),
      ),
    );
  }
}

/// The invite [link] as a QR code and as text, Share, and the waiting
/// animation below.
class _Invite extends StatelessWidget {
  const _Invite({required this.link});

  final Uri link;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: .min,
      children: [
        Text(
          l10n.sea_battle_invite_hint,
          textAlign: .center,
          style: context.typography.regular18.copyWith(color: colors.white50),
        ),
        const SizedBox(height: 20),
        _QrCard(link: link),
        const SizedBox(height: 20),
        _LinkField(link: link),
        const SizedBox(height: 16),
        AppButton(
          label: l10n.sea_battle_share,
          color: colors.blue,
          icon: Icon(Icons.ios_share_rounded, color: colors.white, size: 22),
          onPressed: () => unawaited(_share(context)),
        ),
        const SizedBox(height: 40),
        const _WaitingDots(),
        const SizedBox(height: 12),
        Text(
          l10n.sea_battle_waiting_for_opponent,
          textAlign: .center,
          style: context.typography.regular20,
        ),
      ],
    );
  }

  Future<void> _share(BuildContext context) async {
    // iPads anchor the share sheet to the button that opened it.
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        text: context.l10n.sea_battle_share_message(link.toString()),
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }
}

/// The link as a QR code on a white card, so any phone camera reads it.
class _QrCard extends StatelessWidget {
  const _QrCard({required this.link});

  final Uri link;

  static const _size = 200.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.white,
        borderRadius: .circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: QrImageView(
        data: link.toString(),
        size: _size,
        padding: .zero,
        // The theme's darkest colour keeps the code on-brand and still
        // dark enough to scan.
        eyeStyle: QrEyeStyle(eyeShape: .square, color: colors.secondary),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: .square,
          color: colors.secondary,
        ),
        semanticsLabel: link.toString(),
      ),
    );
  }
}

/// The link without its scheme, with a copy icon; a tap copies it.
class _LinkField extends StatefulWidget {
  const _LinkField({required this.link});

  final Uri link;

  @override
  State<_LinkField> createState() => _LinkFieldState();
}

class _LinkFieldState extends State<_LinkField> {
  late final _controller = TextEditingController(text: _shown(widget.link));

  static String _shown(Uri link) => '${link.host}${link.path}';

  @override
  void didUpdateWidget(_LinkField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.link != oldWidget.link) {
      _controller.text = _shown(widget.link);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.link.toString()));
    if (!mounted) return;
    await showAppNotification(
      context,
      message: context.l10n.sea_battle_link_copied,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppInputField(
      controller: _controller,
      readOnly: true,
      style: context.typography.bodyLarge.copyWith(color: colors.white),
      onPressed: () => unawaited(_copy()),
      suffix: AppIcon(
        icon: Icon(Icons.copy_rounded, color: colors.white),
        onTap: () => unawaited(_copy()),
      ),
    );
  }
}

/// Three dots bouncing one after another.
class _WaitingDots extends StatefulWidget {
  const _WaitingDots();

  @override
  State<_WaitingDots> createState() => _WaitingDotsState();
}

class _WaitingDotsState extends State<_WaitingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  static const _dotCount = 3;
  static const _dotSize = 12.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          for (var i = 0; i < _dotCount; i++)
            Transform.translate(
              // Each dot rises in turn, a third of a cycle apart.
              offset: Offset(
                0,
                -10 *
                    max(
                      0,
                      sin((_controller.value - i / _dotCount) * 2 * pi),
                    ),
              ),
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: colors.white,
                  shape: .circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
