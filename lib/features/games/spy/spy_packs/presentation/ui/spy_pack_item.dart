import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/network_pack_image.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

/// A half-width grid tile for a spy pack. Built-in packs show their cover
/// art; custom (player-created) packs get a solid accent, a "Yours" badge
/// and an edit affordance.
class SpyPackItem extends StatelessWidget {
  const SpyPackItem({
    required this.name,
    required this.imageUrl,
    required this.imageBlurHash,
    required this.onTap,
    this.shouldDownload = false,
    this.isCustom = false,
    this.colorIndex = 0,
    this.onEdit,
    super.key,
  });

  final String name;
  final String imageUrl;
  final String imageBlurHash;
  final VoidCallback onTap;

  /// When true the pack is a not-yet-cached placeholder; a download hint is
  /// shown and tapping triggers the download instead of starting a game.
  final bool shouldDownload;

  /// Whether this is a player-created pack.
  final bool isCustom;

  /// Opens the editor for a custom pack; ignored for built-in packs.
  final VoidCallback? onEdit;

  /// The pack's ordinal among custom packs; cycles the cover gradient so
  /// adjacent custom tiles never share a colour. Ignored for built-in packs.
  final int colorIndex;

  /// The scheme whose gradient dresses this custom pack's cover. Cycling by
  /// [colorIndex] through all 15 schemes keeps neighbours distinct and reuses
  /// the app's own gradient palette.
  AppColors get _coverColors =>
      AppColorScheme.values[colorIndex % AppColorScheme.values.length].colors;

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
              child: isCustom
                  ? _CustomPackArt(scheme: _coverColors, name: name)
                  : imageBlurHash.isEmpty
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
                borderRadius: .circular(12),
                // The scrim only needs to sit behind the single-line title,
                // so keep it to the bottom third instead of half the tile.
                gradient: LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  stops: const [0.0, 0.7, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),
          if (shouldDownload)
            Positioned(
              top: 10,
              right: 10,
              child: Assets.icons.download.svg(height: 22, width: 22),
            ),
          // The edit button is enough to mark a pack as the player's own.
          if (isCustom && onEdit != null)
            Positioned(
              top: 6,
              right: 6,
              child: AppIconButton.edit(onTap: onEdit!),
            ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: FittedBox(
              fit: .scaleDown,
              alignment: .centerLeft,
              child: Text(
                name,
                maxLines: 1,
                style: context.typography.regular20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cover art for a custom pack: one of the app's scheme gradients with the
/// pack's initial centred on top — so player-created packs look intentional
/// next to the illustrated built-in tiles.
class _CustomPackArt extends StatelessWidget {
  const _CustomPackArt({required this.scheme, required this.name});

  final AppColors scheme;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final trimmed = name.trim();
    final initial =
        trimmed.isEmpty ? '' : trimmed.substring(0, 1).toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [scheme.firstGradient, scheme.secondGradient],
        ),
      ),
      child: Center(
        child: Text(
          initial,
          style: context.typography.regular38.copyWith(
            fontSize: 84,
            height: 1,
            color: colors.white,
            // A soft shadow keeps the initial legible on lighter schemes.
            shadows: [
              Shadow(
                color: colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
