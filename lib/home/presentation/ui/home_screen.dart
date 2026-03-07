import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/coin_balance_widget.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:alias_pro/pre_game/presentation/ui/game_settings_screen.dart';
import 'package:alias_pro/rewards/presentation/ui/rewards_screen.dart';
import 'package:alias_pro/rules/presentation/ui/rules_screen.dart';
import 'package:alias_pro/settings/presentation/ui/settings_screen.dart';
import 'package:alias_pro/shop/presentation/ui/shop_screen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GradientBackground(
      child: Column(
        spacing: 20,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const .all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      AppIconButton.settings(
                        onTap: () => context.goNamed(
                          SettingsScreen.routePath,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppIconButton.info(
                        onTap: () => context.goNamed(
                          RulesScreen.routePath,
                        ),
                      ),
                      const Spacer(),
                      CoinBalanceWidget(
                        onTap: () {
                          context.goNamed(ShopScreen.routePath);
                        },
                      ),
                    ],
                  ),
                  height20,
                  SizedBox(
                    height: 165,
                    width: 200,
                    child: Assets.icons.logoAm.svg(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ShadowBackground(
              child: Padding(
                padding: const .symmetric(horizontal: 20),
                child: Column(
                  children: [
                    height40,
                    AppButton(
                      label: 'Classic Alias',
                      color: colors.green,
                      onPressed: () => _navigateToGameSettings(context, .card),
                    ),
                    height20,
                    AppButton(
                      label: 'One Word Mode',
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
                            label: 'Shop',
                            color: colors.blue,
                            onPressed: () {
                              context.goNamed(ShopScreen.routePath);
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
