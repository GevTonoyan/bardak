import 'dart:async';

import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
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

  static const routePath = 'game_session';

  @override
  State<GameSessionScreen> createState() => _GameSessionScreenState();
}

class _GameSessionScreenState extends State<GameSessionScreen> {
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
        create: (_) => GameSessionBloc(initialGameState: session),
        child: BlocListener<GameSessionBloc, GameSessionState>(
          listener: (context, state) {
            if (state.gameState.isGameFinished) {
              context.goNamed(
                GameSummaryScreen.routePath,
                extra: state.gameState.teamStates,
              );
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}
