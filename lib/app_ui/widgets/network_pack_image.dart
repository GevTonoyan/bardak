import 'package:alias_pro/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class NetworkPackImage extends StatelessWidget {
  const NetworkPackImage({
    this.imageUrl,
    this.fit = .fill,
    this.width = double.maxFinite,
    this.height,
    this.opacity = 0.5,
    super.key,
  });

  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Image.network(
            _convertToDirectLink(imageUrl!),
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => _fallbackImage(),
          )
        : _fallbackImage();
  }

  Widget _fallbackImage() {
    return Assets.packImages.mainPack.image(
      fit: fit,
      width: width,
      height: height,
    );
  }

  String _convertToDirectLink(String url) {
    if (url.contains('drive.google.com')) {
      final regExp = RegExp(r'\/d\/(.+)\/view');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }
    }
    return url;
  }
}
