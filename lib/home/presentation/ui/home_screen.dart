import 'dart:async';

import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/coin_balance_widget.dart';
import 'package:bardak/app_ui/widgets/screen_background.dart';
import 'package:bardak/assets/assets.gen.dart';
import 'package:bardak/pre_game/domain/entities/pre_game_entity.dart';
import 'package:bardak/pre_game/presentation/ui/game_settings_screen.dart';
import 'package:bardak/rewards/presentation/ui/rewards_screen.dart';
import 'package:bardak/rules/presentation/ui/rules_screen.dart';
import 'package:bardak/settings/presentation/ui/settings_screen.dart';
import 'package:bardak/splash/presentation/splash_screen.dart';
import 'package:bardak/themes/presentation/ui/themes_screen.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
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
  late final Animation<Offset> _rightSlideAnimation;

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
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
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
                      const SizedBox(width: 10),
                      SlideTransition(
                        position: _leftSlideAnimation,
                        child: AppIconButton.info(
                          onTap: () => context.goNamed(
                            RulesScreen.routePath,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SlideTransition(
                        position: _rightSlideAnimation,
                        child: CoinBalanceWidget(
                          onTap: () {
                            context.goNamed(ThemesScreen.routePath);
                          },
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
                        label: l10n.classicMode,
                        color: colors.green,
                        onPressed: () =>
                            _navigateToGameSettings(context, .card),
                      ),
                      height20,
                      AppButton(
                        label: l10n.oneWordMode,
                        color: colors.purple,
                        onPressed: () =>
                            _navigateToGameSettings(context, .singleWord),
                      ),
                      const Spacer(),
                      Row(
                        spacing: 12,
                        children: [
                          Expanded(
                            child: AppButton(
                              label: context.l10n.rewards,
                              color: colors.white20,
                              onPressed: () =>
                                  context.goNamed(RewardsScreen.routePath),
                            ),
                          ),
                          Expanded(
                            child: AppButton(
                              label: l10n.themes,
                              color: colors.blue,
                              onPressed: () {
                                context.goNamed(ThemesScreen.routePath);
                              },
                            ),
                          ),
                        ],
                      ),
                      height20,
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
    unawaited(
      context.pushNamed(
        GameSettingsScreen.routePath,
        queryParameters: {GameSettingsScreen.gameModeKey: gameMode.name},
      ),
    );
  }
}
