import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/round_timer.dart';
import 'package:alias_pro/app_ui/widgets/show_confirm_sheet.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';

class RoundHeader extends StatefulWidget {
  const RoundHeader({
    required this.initialRoundDuration,
    required this.onRoundComplete,
    required this.onPauseChanged,
    super.key,
  });

  final int initialRoundDuration;
  final VoidCallback onRoundComplete;
  final ValueChanged<bool> onPauseChanged;

  @override
  State<RoundHeader> createState() => _RoundHeaderState();
}

class _RoundHeaderState extends State<RoundHeader>
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
      widget.onPauseChanged(true);
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
            widget.onRoundComplete();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          AppIconButton.close(
            onTap: () async {
              await showConfirmSheet(
                context: context,
                title: l10n.roundOverview_confirmExit_title,
                description: l10n.roundOverview_confirmExit_message,
                confirmText: l10n.general_yes,
                cancelText: l10n.general_no,
                confirmColor: colors.red,
                cancelColor: colors.green,
                onConfirm: () {
                  widget.onRoundComplete();
                },
              );
            },
          ),
          RoundTimer(seconds: remainingSeconds),
          if (isTimerPaused)
            AppIconButton.play(
              onTap: _onPausePlayPressed,
            )
          else
            AppIconButton.pause(
              onTap: _onPausePlayPressed,
            ),
        ],
      ),
    );
  }

  void _onPausePlayPressed() {
    widget.onPauseChanged(!isTimerPaused);
    setState(() {
      if (_timer.isActive) {
        _timer.cancel();
      } else {
        remainingSeconds--;
        _startTimer();
      }
      isTimerPaused = !isTimerPaused;
    });
  }
}
