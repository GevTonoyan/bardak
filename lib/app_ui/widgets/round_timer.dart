import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RoundTimer extends StatelessWidget {
  const RoundTimer({required this.seconds, super.key});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(192);
    final colors = context.colors;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: colors.green,
            border: Border.all(color: colors.white, width: 3),
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 3),
                color: colors.shadow,
              ),
            ],
          ),
          child: Row(
            spacing: 6,
            children: [
              Text(
                seconds.toString(),
                style: context.typography.regular28.copyWith(
                  color: colors.white,
                  fontFamily: 'Digitalt',
                ),
              ),
              Assets.clock.svg(width: 18, height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
