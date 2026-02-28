import 'package:alias_pro/app_ui/widgets/app_icon_text_button.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/rewards/domain/entities/coin_balance_entity.dart';
import 'package:alias_pro/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/int_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinBalanceWidget extends StatelessWidget {
  const CoinBalanceWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
                style: typography.medium.copyWith(
                  color: colors.white,
                  fontFamily: 'Digitalt',
                ),
              ),
              Assets.coin.svg(width: 18, height: 18),
            ],
          ),
        );
      },
    );
  }
}
