import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shown when the player runs out of mistakes.
class SudokuGameOverScreen extends StatelessWidget {
  const SudokuGameOverScreen({super.key});

  static const routePath = 'sudokuGameOver';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Material(
      child: Stack(
        children: [
          GradientBackground(child: Container()),
          Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              const SafeArea(bottom: false, child: SizedBox.shrink()),
              Padding(
                padding: const .symmetric(horizontal: 40),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      l10n.sudoku_game_over,
                      textAlign: .center,
                      style: context.typography.regular28,
                    ),
                    Text(
                      l10n.sudoku_out_of_mistakes(SudokuState.maxMistakes),
                      textAlign: .center,
                      style: context.typography.regular24.copyWith(
                        color: colors.white50,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: Column(
                      children: [
                        AppButton(
                          label: l10n.play_again,
                          color: colors.green,
                          onPressed: () => context.pushReplacementNamed(
                            SudokuScreen.routePath,
                          ),
                        ),
                        height20,
                        AppButton(
                          label: l10n.proceed,
                          color: colors.white20,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
