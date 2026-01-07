// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// Directory path: assets/icons/flags
  $AssetsIconsFlagsGen get flags => const $AssetsIconsFlagsGen();
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/alias.png
  AssetGenImage get alias => const AssetGenImage('assets/images/alias.png');

  /// List of all assets
  List<AssetGenImage> get values => [alias];
}

class $AssetsIconsFlagsGen {
  const $AssetsIconsFlagsGen();

  /// File path: assets/icons/flags/am.svg
  SvgGenImage get am => const SvgGenImage('assets/icons/flags/am.svg');

  /// File path: assets/icons/flags/ru.svg
  SvgGenImage get ru => const SvgGenImage('assets/icons/flags/ru.svg');

  /// File path: assets/icons/flags/uk.svg
  SvgGenImage get uk => const SvgGenImage('assets/icons/flags/uk.svg');

  /// List of all assets
  List<SvgGenImage> get values => [am, ru, uk];
}

class Assets {
  const Assets._();

  static const SvgGenImage back = SvgGenImage('assets/back.svg');
  static const SvgGenImage close = SvgGenImage('assets/close.svg');
  static const SvgGenImage coin = SvgGenImage('assets/coin.svg');
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const SvgGenImage lock = SvgGenImage('assets/lock.svg');
  static const SvgGenImage logoAm = SvgGenImage('assets/logo_am.svg');
  static const SvgGenImage minus = SvgGenImage('assets/minus.svg');
  static const SvgGenImage pause = SvgGenImage('assets/pause.svg');
  static const SvgGenImage play = SvgGenImage('assets/play.svg');
  static const SvgGenImage plus = SvgGenImage('assets/plus.svg');
  static const SvgGenImage question = SvgGenImage('assets/question.svg');
  static const SvgGenImage rewardClosed = SvgGenImage(
    'assets/reward_closed.svg',
  );
  static const SvgGenImage rewardOpened = SvgGenImage(
    'assets/reward_opened.svg',
  );
  static const SvgGenImage shadowEffect = SvgGenImage(
    'assets/shadow_effect.svg',
  );
  static const SvgGenImage shiner = SvgGenImage('assets/shiner.svg');
  static const SvgGenImage volume = SvgGenImage('assets/volume.svg');

  /// List of all assets
  static List<SvgGenImage> get values => [
    back,
    close,
    coin,
    lock,
    logoAm,
    minus,
    pause,
    play,
    plus,
    question,
    rewardClosed,
    rewardOpened,
    shadowEffect,
    shiner,
    volume,
  ];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
