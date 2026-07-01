import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/extensions/int_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinBalanceWidget extends StatelessWidget {
  const CoinBalanceWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return BlocBuilder<RewardsCubit, RewardsState>(
      builder: (context, state) {
        final coins = state.coinBalance.coins;

        return AppIconTextButton(
          onTap: onTap,
          child: Row(
            spacing: 6,
            children: [
              Text(
                coins.toDotThousands,
                style: typography.medium.withNumericFont,
              ),
              Assets.icons.coin.svg(width: 18, height: 18),
            ],
          ),
        );
      },
    );
  }
}
