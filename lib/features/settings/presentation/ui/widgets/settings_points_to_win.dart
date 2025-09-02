import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPointsToWin extends StatelessWidget {
  const SettingsPointsToWin({required this.pointsToWin, super.key});

  final int pointsToWin;

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
              context.l10n.settings_pointsToWin,
              style: typography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              spacing: 8,
              children:
                  [30, 60, 90, 120].map((points) {
                    final isSelected = points == pointsToWin;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: 60,
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.read<SettingsBloc>().add(
                              ChangePointsToWin(pointsToWin: points),
                            );
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
                                '$points',
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
