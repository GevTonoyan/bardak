import 'dart:async';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:boardify/core/ui_kit/widgets/game_popup_dialog.dart';
import 'package:boardify/features/round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardRoundHeader extends StatefulWidget {
  const CardRoundHeader({required this.initialRoundDuration, super.key});

  final int initialRoundDuration;

  @override
  State<CardRoundHeader> createState() => _RoundHeaderState();
}

class _RoundHeaderState extends State<CardRoundHeader>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late int remainingSeconds;
  late Timer _timer;
  bool isTimerPaused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    remainingSeconds = widget.initialRoundDuration;
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      setState(() {
        isTimerPaused = true;
      });
      _timer.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isTimerPaused) {
        setState(() {
          if (remainingSeconds > 0) {
            --remainingSeconds;
          } else {
            timer.cancel();
            context.read<CardRoundBloc>().add(const CompleteRoundRequested());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color timeColor() {
      if (remainingSeconds <= 5) return colors.error;
      if (remainingSeconds <= 10) return colors.warning;
      return colors.success;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            '$remainingSeconds',
            style: typography.displayLarge.copyWith(
              color: timeColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isTimerPaused ? Icons.play_arrow : Icons.pause,
              color: colors.primary,
            ),
            onPressed: () {
              setState(() {
                if (_timer.isActive) {
                  _timer.cancel();
                } else {
                  remainingSeconds--;
                  _startTimer();
                }
                isTimerPaused = !isTimerPaused;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: colors.error),
            onPressed: () {
              showGamePopupDialog(
                context: context,
                title: context.l10n.alias_roundOverview_confirmExit_title,
                message: context.l10n.alias_roundOverview_confirmExit_message,
                confirmText: context.l10n.general_yes,
                cancelText: context.l10n.general_no,
                onConfirm:
                    () => context.read<CardRoundBloc>().add(
                      const CompleteRoundRequested(),
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}
