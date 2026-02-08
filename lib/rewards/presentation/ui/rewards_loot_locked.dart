import 'dart:math' as math;

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:boardify/shop/presentation/ui/shop_screen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RewardsLootLocked extends StatelessWidget {
  const RewardsLootLocked({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final coinBalance = context.read<RewardsCubit>().state;
    final rewards = coinBalance.openedBoxes.values
        .take(maxOpensPerDay)
        .toList(growable: false);

    final totalReward = rewards.fold<int>(0, (acc, x) => acc + x);

    return Column(
      mainAxisAlignment: .spaceBetween,
      children: [
        Padding(
          padding: const .symmetric(horizontal: 44),
          child: Column(
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: .center,
                spacing: 10,
                children: rewards.map((reward) {
                  return Stack(
                    alignment: .center,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Assets.rewardOpened.svg(),
                      ),
                      Transform.rotate(
                        angle: 9.25 * math.pi / 180 * 2,
                        child: Text(
                          reward.toString(),
                          style: context.typography.regular28.copyWith(
                            fontFamily: 'Digitalt',
                            color: context.colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Text(
                'Հիանալի է!  Դուք ստացաք $totalReward միավոր',
                textAlign: .center,
                style: context.typography.regular28.copyWith(
                  color: colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const .symmetric(horizontal: 20, vertical: 44),
          child: Column(
            spacing: 20,
            children: [
              AppButton(
                label: 'Շարունակել',
                color: colors.green,
                onPressed: () => context.pop(),
              ),
              AppButton(
                label: 'Խանութ',
                color: colors.blue,
                onPressed: () => context.goNamed(ShopScreen.routePath),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
