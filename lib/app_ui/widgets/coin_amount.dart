import 'package:boardify/app_ui/widgets/app_icon_text_button.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:boardify/utils/extensions/int_extension.dart';
import 'package:flutter/material.dart';

class CoinAmount extends StatelessWidget {
  const CoinAmount({required this.amount, this.onTap, super.key});

  final int amount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return AppIconTextButton(
      onTap: onTap,
      child: Row(
        spacing: 6,
        children: [
          Text(
            amount.toDotThousands,
            style: typography.medium.copyWith(
              color: colors.white,
              fontFamily: 'Digitalt',
            ),
          ),
          Assets.coin.svg(width: 18, height: 18),
        ],
      ),
    );
  }
}
