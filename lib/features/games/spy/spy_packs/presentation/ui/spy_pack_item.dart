import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/network_pack_image.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// A half-width grid tile for a spy pack.
class SpyPackItem extends StatelessWidget {
  const SpyPackItem({
    required this.name,
    required this.imageUrl,
    required this.imageBlurHash,
    required this.onTap,
    super.key,
  });

  final String name;
  final String imageUrl;
  final String imageBlurHash;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      label: name,
      color: colors.white20,
      size: .extraLarge,
      onPressed: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: .circular(12),
              child: imageUrl.isEmpty
                  ? ColoredBox(color: colors.secondary)
                  : NetworkPackImage(
                      imageUrl: imageUrl,
                      imageBlurHash: imageBlurHash,
                    ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  stops: const [0.0, 0.55, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Text(
              name,
              maxLines: 2,
              overflow: .ellipsis,
              style: context.typography.regular20,
            ),
          ),
        ],
      ),
    );
  }
}
