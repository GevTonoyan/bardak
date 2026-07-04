import 'dart:math' as math;

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/app_ui/widgets/text_with_border.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/features/themes/presentation/ui/themes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RewardsLootLocked extends StatelessWidget {
  const RewardsLootLocked({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final coinBalance = context.read<RewardsCubit>().state.coinBalance;
    final rewards = coinBalance.openedBoxes.values
        .take(maxBoxesPerDay)
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
                      Positioned(
                        bottom: 10,
                        child: Transform.rotate(
                          angle: 9.25 * math.pi / 180 * 2,
                          child: TextWithBorder(
                            reward.toString(),
                            style: context.typography.regular28.withNumericFont,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SmartNumberText(
                l10n.rewards_success(totalReward),
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
                label: l10n.proceed,
                color: colors.green,
                onPressed: () => context.pop(),
              ),
              AppButton(
                label: l10n.themes,
                color: colors.blue,
                onPressed: () => context.goNamed(ThemesScreen.routePath),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
