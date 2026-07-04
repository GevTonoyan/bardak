import 'dart:async';

import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_state.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/game_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({
    required this.gameSessionEntity,
    required this.child,
    super.key,
  });

  final GameSessionEntity? gameSessionEntity;
  final Widget child;

  static const routePath = 'gameSession';

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
  // GoRouter rebuilds the shell with a null `extra` when navigating between
  // round screens, so the first non-null session is cached for the shell's
  // lifetime.
  GameSessionEntity? _cached;

  @override
  void initState() {
    super.initState();
    _cached = widget.gameSessionEntity;
  }

  @override
  void didUpdateWidget(covariant GameSessionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cached ??= widget.gameSessionEntity;
  }

  @override
  Widget build(BuildContext context) {
    final session = _cached;
    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('Missing game session. Start a new game.')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final l10n = context.l10n;
        final colors = context.colors;
        unawaited(
          showConfirmSheet(
            context: context,
            title: l10n.exit_game_title,
            description: l10n.exit_game_description,
            confirmText: l10n.exit_game_confirm,
            cancelText: l10n.cancel,
            confirmColor: colors.red,
            cancelColor: colors.green,
            onConfirm: () => context.pop(),
          ),
        );
      },
      child: BlocProvider(
        create: (_) => GameSessionBloc(initialSession: session),
        child: BlocListener<GameSessionBloc, GameSessionState>(
          listenWhen: (previous, current) =>
              !previous.session.isGameFinished &&
              current.session.isGameFinished,
          listener: (context, state) {
            final winningTeamIndex = state.session.winningTeamIndex;
            if (winningTeamIndex == null) return;

            context.goNamed(
              GameSummaryScreen.routePath,
              extra: state.session.teams[winningTeamIndex].name,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}
