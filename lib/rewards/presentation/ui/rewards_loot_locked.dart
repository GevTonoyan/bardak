import 'dart:math' as math;

import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/smart_number_text.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:alias_pro/shop/presentation/ui/shop_screen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
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
      children: [
        height40,
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
                        child: Assets.icons.rewardOpened.svg(),
                      ),
                      Transform.rotate(
                        angle: 9.25 * math.pi / 180 * 2,
                        child: Text(
                          reward.toString(),
                          style: context.typography.regular28.withNumericFont,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SmartNumberText(
                'Հիանալի է!  Դուք ստացաք $totalReward միավոր',
                textAlign: .center,
                style: context.typography.regular28,
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const .all(20),
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
