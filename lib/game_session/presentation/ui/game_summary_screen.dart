import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameSummaryScreen extends StatelessWidget {
  const GameSummaryScreen({required this.winningTeamName, super.key});

  static const routePath = 'game_summary';
  final String winningTeamName;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.summary_gameOver,
                      style: typography.headlineLarge.copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.primary,
                              colors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 48,
                              color: colors.onPrimary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.l10n.summary_winner,
                              style: typography.titleMedium.copyWith(
                                color: colors.onPrimary.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              winningTeamName,
                              textAlign: TextAlign.center,
                              style: typography.headlineMedium.copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.goNamed(PreGameScreen.routePath),
                      icon: const Icon(Icons.refresh),
                      label: Text(context.l10n.summary_playAgain),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.home),
                      label: Text(context.l10n.summary_mainMenu),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
