import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/game_session/domain/entities/card_round_result.dart';
import 'package:boardify/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/card_round/presentation/ui/widgets/card_round_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardRoundScreen extends StatelessWidget {
  const CardRoundScreen({required this.initialRoundDuration, super.key});

  static const routePath = 'card_round';

  final int initialRoundDuration;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardRoundBloc, CardRoundState>(
      listener: (context, state) {
        if (state.completed) {
          context.pop(
            RoundResult(
              guessedCount: state.guessed.length,
              seenWordsCount: state.seenWordsCount,
            ),
          );
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                RoundHeader(
                  initialRoundDuration: initialRoundDuration,
                  onRoundComplete: () {
                    context.read<CardRoundBloc>().add(
                      const CompleteRoundRequested(),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const CardRoundList(),
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
