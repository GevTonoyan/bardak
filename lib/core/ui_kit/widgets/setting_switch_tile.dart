import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SettingSwitchTile extends StatelessWidget {
  const SettingSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final bool value;

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SwitchListTile(
        title: Text(
          title,
          style: typography.bodyMedium.copyWith(color: colors.onSurface),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
