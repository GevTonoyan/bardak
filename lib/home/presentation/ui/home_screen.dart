import 'dart:async';

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/app_ui/widgets/coin_balance_widget.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/pre_game/presentation/ui/pre_game_settings_screen.dart';
import 'package:boardify/rewards/presentation/ui/rewards_screen.dart';
import 'package:boardify/rules/presentation/ui/rules_screen.dart';
import 'package:boardify/settings/presentation/ui/settings_screen_v2.dart';
import 'package:boardify/shop/presentation/ui/shop_screen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      child: Stack(
        children: [
          Scaffold(
            body: Container(
              decoration: BoxDecoration(gradient: colors.main),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
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
                        width: 279,
                        child: Assets.logoAm.svg(),
                      ),
                      height20,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset('assets/shadow_effect.svg'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 100),
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  label: 'Classic Alias',
                  color: colors.green,
                  onPressed: () => _navigateToGameSettings(context, .card),
                ),
                AppButton(
                  label: 'One Word Mode',
                  color: colors.purple,
                  onPressed: () =>
                      _navigateToGameSettings(context, .singleWord),
                ),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 44),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Rewards',
                      color: colors.white20,
                      onPressed: () => context.goNamed(RewardsScreen.routePath),
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
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGameSettings(BuildContext context, GameMode gameMode) {
    unawaited(
      context.pushNamed(
        PreGameSettingsScreen.routePath,
        queryParameters: {PreGameSettingsScreen.gameModeKey: gameMode.name},
      ),
    );
  }
}
