import 'dart:math' as math;

import 'package:boardify/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:boardify/rewards/presentation/ui/reward_item.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsLootGrid extends StatelessWidget {
  const RewardsLootGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colors.white,
        boxShadow: [
          BoxShadow(color: colors.shadow, offset: const Offset(0, 12)),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: EdgeInsets.zero,
        children: List.generate(9, (index) {
          final cubit = context.watch<RewardsCubit>();

          final boxInfo = cubit.state.openedBoxes[index];

          final isOpened = boxInfo != null;
          final coins = boxInfo;

          return RewardItem(
            isFront: !isOpened,
            coins: coins,
            onTap: () async {
              final coins = (math.Random().nextInt(10) + 1) * 10;
              await cubit.updateCoins(index, coins);
            },
          );
        }),
      ),
    );
  }
}
