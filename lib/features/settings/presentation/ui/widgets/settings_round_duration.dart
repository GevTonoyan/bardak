import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SettingsRoundDuration extends StatelessWidget {
  const SettingsRoundDuration({
    required this.roundDuration,
    required this.onDurationChanged,
    super.key,
  });

  final int roundDuration;
  final void Function(int) onDurationChanged;

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
            Text(
              context.l10n.settings_roundDuration,
              style: typography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children:
                  [30, 60, 90, 120].map((duration) {
                    final isSelected = duration == roundDuration;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: 60,
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            onDurationChanged(duration);
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
                                '$duration',
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
