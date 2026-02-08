import 'package:boardify/app_ui/widgets/app_icon_text_button.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/rewards/domain/entities/coin_balance_entity.dart';
import 'package:boardify/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:boardify/utils/extensions/int_extension.dart';
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
