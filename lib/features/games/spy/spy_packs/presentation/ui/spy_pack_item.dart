import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/network_pack_image.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SpyPackItem extends StatelessWidget {
  const SpyPackItem({
    required this.name,
    required this.wordsCount,
    required this.imageUrl,
    required this.imageBlurHash,
    required this.onTap,
    super.key,
  });

  final String name;
  final int wordsCount;
  final String imageUrl;
  final String imageBlurHash;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return AppButton(
      label: name,
      color: colors.white20,
      size: .extraLarge,
      onPressed: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: .circular(12),
            child: imageUrl.isEmpty
                ? Container(color: colors.secondary)
                : NetworkPackImage(
                    imageUrl: imageUrl,
                    imageBlurHash: imageBlurHash,
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.transparent,
                    colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              wordsCount.toString(),
              style: typography.regular24.withNumericFont,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              name,
              style: typography.regular24,
            ),
          ),
        ],
      ),
    );
  }
}
