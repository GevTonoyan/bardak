import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class PackCard extends StatelessWidget {
  const PackCard({
    required this.packName,
    required this.emoji,
    required this.startColor,
    required this.endColor,
    required this.onTap,
    this.isSelected = false,
    super.key,
  });

  final String packName;
  final String emoji;
  final Color startColor;
  final Color endColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: endColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            if (isSelected)
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 10,
                spreadRadius: 2,
              ),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 12,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            Text(
              packName,
              style: text.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
