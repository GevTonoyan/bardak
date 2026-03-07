import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/coin_balance_widget.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/rewards/domain/entities/coin_balance_entity.dart';
import 'package:alias_pro/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:alias_pro/rewards/presentation/ui/rewards_loot_grid.dart';
import 'package:alias_pro/rewards/presentation/ui/rewards_loot_locked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const routePath = 'rewards';

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                  const CoinBalanceWidget(),
                ],
              ),
            ),
          ),
          height40,
          Expanded(
            child: ShadowBackground(
              child: BlocBuilder<RewardsCubit, CoinBalanceEntity>(
                builder: (context, coinsBalance) {
                  return coinsBalance.openedCountToday >= maxOpensPerDay
                      ? const RewardsLootLocked()
                      : const RewardsLootGrid();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
