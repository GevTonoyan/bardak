import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({required this.value, required this.onChanged, super.key});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Switch(
      activeThumbColor: colors.green,
      activeTrackColor: colors.white,
      inactiveThumbColor: colors.white,
      inactiveTrackColor: colors.white20,
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (_) => colors.white20,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      value: value,
      onChanged: onChanged,
    );
  }
}
