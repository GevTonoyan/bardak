import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/ui/game_settings_screen.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/ui/spy_settings_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/ui/sudoku_settings_screen.dart';
import 'package:bardak/features/settings/presentation/ui/settings_screen.dart';
import 'package:bardak/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routePath = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<Offset> _leftSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return GradientBackground(
      child: Column(
        spacing: 20,
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const .all(20),
                  child: Row(
                    children: [
                      SlideTransition(
                        position: _leftSlideAnimation,
                        child: AppIconButton.settings(
                          onTap: () => context.goNamed(
                            SettingsScreen.routePath,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Hero(
                  tag: SplashScreen.heroTag,
                  child: Assets.images.logo.image(
                    height: 220,
                    width: 220,
                    fit: .contain,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: SlideTransition(
              position: _slideAnimation,
              child: ShadowBackground(
                child: Padding(
                  padding: const .symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      height40,
                      AppButton(
                        label: l10n.alias,
                        color: colors.green,
                        onPressed: () =>
                            _navigateToGameSettings(context, .card),
                      ),
                      height20,
                      AppButton(
                        label: l10n.spyMode,
                        color: colors.purple,
                        onPressed: () => unawaited(
                          context.pushNamed(SpySettingsScreen.routePath),
                        ),
                      ),
                      height20,
                      AppButton(
                        label: l10n.sudoku,
                        color: colors.orange,
                        onPressed: () => unawaited(
                          context.pushNamed(SudokuSettingsScreen.routePath),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGameSettings(BuildContext context, GameMode gameMode) {
    context.read<GameSettingsBloc>().add(ChangeGameMode(gameMode));
    unawaited(context.pushNamed(GameSettingsScreen.routePath));
  }
}
