import 'package:bardak/core/app_ui/widgets/app_error_view.dart';
import 'package:bardak/core/app_ui/widgets/app_loader.dart';
import 'package:bardak/core/app_ui/widgets/app_screen_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Where an invite link lands: joins the friend's room with [code] and
/// moves on to placement, or says why it could not.
class SeaBattleJoinRoomScreen extends StatelessWidget {
  const SeaBattleJoinRoomScreen({required this.code, super.key});

  static const routePath = '$routeName/:$codeParameter';
  static const routeName = 'seaBattleJoin';
  static const codeParameter = 'code';

  final String code;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SeaBattleJoinRoomBloc, SeaBattleJoinRoomState>(
      listenWhen: (previous, current) => current is SeaBattleJoinRoomJoined,
      listener: (context, state) => context.pushReplacementNamed(
        SeaBattlePlacementScreen.routePath,
        extra: SeaBattlePlacementArgs(
          mode: .online,
          room: (state as SeaBattleJoinRoomJoined).room,
        ),
      ),
      child: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const .fromLTRB(16, 16, 16, 20),
            child: Column(
              children: [
                AppScreenHeader(
                  title: context.l10n.sea_battle_join_title,
                  onBack: context.pop,
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const .symmetric(vertical: 24),
                      child: _JoinRoomBody(code: code),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A spinner while joining, or why joining failed.
class _JoinRoomBody extends StatelessWidget {
  const _JoinRoomBody({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final failure = context
        .select<SeaBattleJoinRoomBloc, SeaBattleRoomFailure?>(
          (bloc) => switch (bloc.state) {
            SeaBattleJoinRoomFailure(:final reason) => reason,
            _ => null,
          },
        );

    return failure == null
        ? AppLoader(label: context.l10n.sea_battle_joining)
        : _JoinRoomFailure(failure: failure, code: code);
  }
}

/// Retry for a lost connection; Back when the room is gone or taken,
/// as trying again would not help.
class _JoinRoomFailure extends StatelessWidget {
  const _JoinRoomFailure({required this.failure, required this.code});

  final SeaBattleRoomFailure failure;
  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return switch (failure) {
      .connection => AppErrorView(
        icon: Icons.wifi_off_rounded,
        message: l10n.sea_battle_connection_error,
        actionLabel: l10n.retry,
        actionColor: colors.green,
        onAction: () =>
            context.read<SeaBattleJoinRoomBloc>().add(JoinRoom(code)),
      ),
      .notFound => AppErrorView(
        icon: Icons.link_off_rounded,
        message: l10n.sea_battle_room_not_found,
        actionLabel: l10n.back,
        actionColor: colors.blue,
        onAction: context.pop,
      ),
      .full => AppErrorView(
        icon: Icons.groups_rounded,
        message: l10n.sea_battle_room_full,
        actionLabel: l10n.back,
        actionColor: colors.blue,
        onAction: context.pop,
      ),
    };
  }
}
