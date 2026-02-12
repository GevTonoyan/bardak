import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class WordPackItem extends StatelessWidget {
  const WordPackItem({
    required this.name,
    required this.packWordsCount,
    required this.shouldDownload,
    required this.onTap,
    this.onDownload,
    super.key,
  });

  final String name;
  final int packWordsCount;
  final bool shouldDownload;
  final VoidCallback onTap;
  final VoidCallback? onDownload;

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
            borderRadius: BorderRadius.circular(12),
            child: Opacity(
              opacity: 0.5,
              child: Assets.packImages.mainPack.image(
                fit: BoxFit.fill,
                width: double.maxFinite,
              ),
            ),
          ),
          if (!shouldDownload)
            Positioned(
              top: 10,
              right: 10,
              child: Text(
                packWordsCount.toString(),
                style: typography.regular24.copyWith(
                  color: colors.white,
                  fontFamily: 'Digitalt',
                ),
              ),
            ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Row(
              spacing: 8,
              children: [
                if (shouldDownload)
                  GestureDetector(
                    onTap: () => onDownload?.call(),
                    child: Assets.download.svg(height: 32, width: 32),
                  ),
                Text(
                  name,
                  style: typography.regular24.copyWith(color: colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
