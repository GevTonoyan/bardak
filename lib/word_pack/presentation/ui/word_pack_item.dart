import 'package:bardak/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/network_pack_image.dart';
import 'package:bardak/assets/assets.gen.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class WordPackItem extends StatelessWidget {
  const WordPackItem({
    required this.name,
    required this.packWordsCount,
    required this.shouldDownload,
    required this.onTap,
    required this.imageUrl,
    required this.imageBlurHash,
    super.key,
  });

  final String name;
  final int packWordsCount;
  final bool shouldDownload;
  final VoidCallback onTap;
  final String imageUrl;
  final String imageBlurHash;

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
            child: NetworkPackImage(
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

          if (!shouldDownload)
            Positioned(
              top: 10,
              right: 10,
              child: Text(
                packWordsCount.toString(),
                style: typography.regular24.withNumericFont,
              ),
            ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Row(
              spacing: 8,
              children: [
                if (shouldDownload)
                  Assets.icons.download.svg(height: 24, width: 24),
                Text(
                  name,
                  style: typography.regular24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
