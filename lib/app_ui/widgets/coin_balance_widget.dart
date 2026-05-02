import 'package:bardak/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/assets/assets.gen.dart';
import 'package:bardak/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:bardak/utils/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinBalanceWidget extends StatelessWidget {
  const CoinBalanceWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return BlocBuilder<RewardsCubit, CoinBalanceEntity>(
      builder: (context, state) {
        final coins = state.coins;

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
