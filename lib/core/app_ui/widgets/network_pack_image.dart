import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class NetworkPackImage extends StatelessWidget {
  const NetworkPackImage({
    required this.imageUrl,
    required this.imageBlurHash,
    this.fit = .fill,
    this.width = double.maxFinite,
    this.height,
    this.opacity = 0.5,
    super.key,
  });

  final String imageUrl;
  final String imageBlurHash;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        BlurHash(
          hash: imageBlurHash,
          imageFit: BoxFit.cover,
        ),
        CachedNetworkImage(
          imageUrl: _convertToDirectLink(imageUrl),
          fit: .cover,
          width: double.maxFinite,
          placeholder: (_, _) => const SizedBox.shrink(),
          errorWidget: (_, _, _) => const SizedBox.shrink(),
          fadeInDuration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  String _convertToDirectLink(String url) {
    if (url.contains('drive.google.com')) {
      final regExp = RegExp('/d/(.+)/view');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://drive.google.com/uc?export=view&id=$fileId';
      }
    }
    return url;
  }
}
