import 'package:flutter/material.dart';

class NeumorphicToggle extends StatelessWidget {
  const NeumorphicToggle({
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
    this.height = 48,
  });

  final List<String> options;
  final int selectedIndex;
  final void Function(int) onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = theme.colorScheme.surface;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(height / 2),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.white,
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: isDark ? Colors.white12 : Colors.black12,
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: height,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? theme.colorScheme.primary : baseColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                child: Text(
                  options[i],
                  style: theme.textTheme.labelLarge!.copyWith(
                    color:
                        selected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
