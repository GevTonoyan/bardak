import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SettingOptionChips extends StatelessWidget {
  const SettingOptionChips({
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onOptionChanged,
    super.key,
  });

  final String title;
  final List<int> options;
  final int currentValue;
  final void Function(int) onOptionChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: typography.bodyMedium),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children:
                  options.map((option) {
                    final isSelected = option == currentValue;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: 60,
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onOptionChanged(option);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? colors.primary
                                      : colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  isSelected
                                      ? null
                                      : Border.all(
                                        color: colors.outline.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                            ),
                            child: Center(
                              child: Text(
                                '$option',
                                style: typography.bodyMedium.copyWith(
                                  color:
                                      isSelected
                                          ? colors.onPrimary
                                          : colors.onSurface,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
