import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageAssetPath;
  final VoidCallback onTap;
  final String heroTag;

  const GameCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: heroTag,
                child: Image.asset(imageAssetPath, height: 64, width: 64, fit: BoxFit.contain),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium.copyWith(color: colors.onSurface)),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: text.bodySmall.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
