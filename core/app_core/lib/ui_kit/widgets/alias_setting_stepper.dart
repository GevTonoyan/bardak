import 'dart:async';

import 'package:app_core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AliasSettingStepper extends StatefulWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final void Function(int value, {bool persist}) onChanged;

  const AliasSettingStepper({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<AliasSettingStepper> createState() => _SettingStepperState();
}

class _SettingStepperState extends State<AliasSettingStepper> {
  Timer? _holdTimer;
  int _lastValue = 0;

  void _startChanging(bool increment) {
    _changeValue(increment, persist: false);
    _holdTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      _changeValue(increment, persist: false);
    });
  }

  void _stopChanging() {
    _holdTimer?.cancel();
    _holdTimer = null;
    if (_lastValue != widget.value) {
      widget.onChanged(widget.value, persist: true);
    }
  }

  void _changeValue(bool increment, {required bool persist}) {
    final next = increment ? widget.value + 1 : widget.value - 1;
    if (next >= widget.min && next <= widget.max) {
      _lastValue = widget.value;
      widget.onChanged(next, persist: persist);
    }
  }

  @override
  void dispose() {
    _stopChanging();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;
    final colors = context.appTheme.colors;

    final bool canDecrement = widget.value > widget.min;
    final bool canIncrement = widget.value < widget.max;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(widget.label, style: text.bodyMedium.copyWith(color: colors.onSurface)),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _changeValue(false, persist: true),
                    onLongPressStart: (_) => _startChanging(false),
                    onLongPressEnd: (_) => _stopChanging(),
                    child: Icon(
                      Icons.remove_circle,
                      size: 32,
                      color: canDecrement ? colors.primary : colors.outline,
                    ),
                  ),
                  Text(
                    '${widget.value}',
                    style: text.titleMedium.copyWith(color: colors.onSurface),
                  ),
                  GestureDetector(
                    onTap: () => _changeValue(true, persist: true),
                    onLongPressStart: (_) => _startChanging(true),
                    onLongPressEnd: (_) => _stopChanging(),
                    child: Icon(
                      Icons.add_circle,
                      size: 32,
                      color: canIncrement ? colors.primary : colors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
