import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/round_timer.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/extensions/state_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class RoundHeader extends StatefulWidget {
  const RoundHeader({
    required this.initialRoundDuration,
    required this.isSoundEnabled,
    required this.onRoundComplete,
    required this.onPauseChanged,
    this.formatTimerAsMinutes = false,
    this.timerOrangeBelow = 10,
    this.timerRedBelow = 5,
    this.onClosePressed,
    super.key,
  });

  final int initialRoundDuration;
  final bool isSoundEnabled;
  final VoidCallback onRoundComplete;
  final ValueChanged<bool> onPauseChanged;

  /// Forwarded to [RoundTimer]; see its fields for details.
  final bool formatTimerAsMinutes;
  final int timerOrangeBelow;
  final int timerRedBelow;

  /// Replaces the default close behavior (confirm sheet → [onRoundComplete]).
  /// The timer pauses while the callback runs and resumes afterwards unless
  /// the screen navigated away or was already paused.
  final Future<void> Function()? onClosePressed;

  @override
  State<RoundHeader> createState() => RoundHeaderState();
}

class RoundHeaderState extends State<RoundHeader>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AudioPlayer _audioPlayer;
  late int remainingSeconds;
  late Timer _timer;
  bool isTimerPaused = false;

  void resume() {
    if (isTimerPaused) {
      _onPausePlayPressed();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    remainingSeconds = widget.initialRoundDuration;
    _audioPlayer = AudioPlayer();
    unawaited(_audioPlayer.setPlayerMode(PlayerMode.lowLatency));
    // Keep the screen awake for the round — players may not touch the phone
    // for minutes (spy), so the idle timer must not dim or lock it.
    unawaited(WakelockPlus.enable());
    _startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    unawaited(_audioPlayer.dispose());
    unawaited(WakelockPlus.disable());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == .inactive) {
      widget.onPauseChanged(true);
      setState(() {
        isTimerPaused = true;
      });
      _timer.cancel();
      unawaited(_audioPlayer.stop());
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

        if (remainingSeconds == 5 && widget.isSoundEnabled) {
          unawaited(_audioPlayer.play(AssetSource(Assets.sounds.tick)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const .only(left: 20, right: 20, top: 20),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          AppIconButton.close(
            onTap: () async {
              final wasPaused = isTimerPaused;
              widget.onPauseChanged(true);
              setState(() {
                isTimerPaused = true;
              });
              _timer.cancel();

              if (widget.onClosePressed case final onClosePressed?) {
                await onClosePressed();
                if (mounted && !wasPaused) resume();
                return;
              }

              await showConfirmSheet(
                context: context,
                title: l10n.round_stop_title,
                description: l10n.round_stop_description,
                confirmText: l10n.round_stop_confirm,
                cancelText: l10n.round_stop_resume,
                confirmColor: colors.red,
                cancelColor: colors.green,
                onConfirm: () {
                  widget.onRoundComplete();
                },
              );
            },
          ),
          RoundTimer(
            seconds: remainingSeconds,
            formatAsMinutes: widget.formatTimerAsMinutes,
            orangeBelow: widget.timerOrangeBelow,
            redBelow: widget.timerRedBelow,
          ),
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
