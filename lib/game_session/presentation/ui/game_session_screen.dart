import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/round_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameSessionScreen extends StatefulWidget {
  const GameSessionScreen({required this.gameSessionEntity, super.key});

  final GameSessionEntity? gameSessionEntity;

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

    return BlocProvider(
      create: (_) => GameSessionBloc(initialGameState: session),
      child: const RoundOverviewScreen(),
    );
  }
}
