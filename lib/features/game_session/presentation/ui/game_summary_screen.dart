import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({required this.winningTeamName, super.key});

  static const routePath = 'game_summary';
  final String winningTeamName;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final textStyles = context.appTheme.typography;

    return Scaffold(
      backgroundColor: colors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.surface, colors.background, colors.surfaceVariant],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🏆 Winner Title
                Text(
                  '🏆 WINNER 🏆',
                  textAlign: TextAlign.center,
                  style: textStyles.displaySmall.copyWith(
                    color: colors.primary,
                    shadows: [
                      Shadow(
                        color: colors.primary.withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                /// 🌟 Winning Team Name
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 48,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary.withOpacity(0.9),
                        colors.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    winningTeamName,
                    textAlign: TextAlign.center,
                    style: textStyles.displayMedium.copyWith(
                      color: colors.onPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 80),

                /// 🕹️ Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GameButton(
                        label: 'Play Again',
                        onTap: () => Navigator.of(context).pop('playAgain'),
                        color: colors.primary,
                        textColor: colors.onPrimary,
                      ),
                      const SizedBox(width: 16),
                      _GameButton(
                        label: 'Main Menu',
                        onTap: () => Navigator.of(context).pop('menu'),
                        color: colors.surface,
                        textColor: colors.onSurface,
                        outlined: true,
                        outlineColor: colors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  const _GameButton({
    required this.label,
    required this.onTap,
    required this.color,
    required this.textColor,
    this.outlined = false,
    this.outlineColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool outlined;
  final Color? outlineColor;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTheme.typography;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(16),
          border:
              outlined
                  ? Border.all(color: outlineColor ?? color, width: 2)
                  : null,
          boxShadow:
              outlined
                  ? []
                  : [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
        ),
        child: Text(
          label,
          style: textStyles.titleMedium.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
