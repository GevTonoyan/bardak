import 'package:equatable/equatable.dart';

/// Describes a single spy pack with its ID, name, words and cover image.
class SpyPackEntity extends Equatable {
  const SpyPackEntity({
    required this.id,
    required this.name,
    required this.words,
    required this.image,
    required this.imageBlurHash,
    this.order = unorderedOrder,
    this.isCustom = false,
  });

  /// Creates a [SpyPackEntity] from a JSON map (e.g. a Firestore doc).
  ///
  /// The image fields are optional so packs stay usable while their
  /// artwork is not uploaded yet. A pack with no [order] (e.g. one not yet
  /// re-uploaded) falls back to [unorderedOrder] so it sorts last.
  factory SpyPackEntity.fromJson(String id, Map<String, dynamic> json) {
    return SpyPackEntity(
      id: id,
      name: json[_nameKey] as String,
      words: List<String>.from(json[_wordsKey] as List? ?? const []),
      image: json[_imageKey] as String? ?? '',
      imageBlurHash: json[_imageBlurHashKey] as String? ?? '',
      order: json[_orderKey] as int? ?? unorderedOrder,
    );
  }

  /// Order given to a pack that has none (missing from Firestore, or a
  /// player-created pack), so such packs sort after every explicitly-ordered
  /// pack rather than jumping to the front.
  static const int unorderedOrder = 1 << 20;

  static const _nameKey = 'name';
  static const _wordsKey = 'words';
  static const _imageKey = 'image';
  static const _imageBlurHashKey = 'image_blur_hash';
  static const _orderKey = 'order';

  final String id;
  final String name;
  final List<String> words;
  final String image;
  final String imageBlurHash;

  /// Display order among built-in packs; lower shows first. Defaults to
  /// [unorderedOrder] when unknown.
  final int order;

  /// True for packs the player created on-device; drives the "Yours" tile
  /// styling and edit/delete affordances.
  final bool isCustom;

  @override
  List<Object> get props => [
    id,
    name,
    words,
    image,
    imageBlurHash,
    order,
    isCustom,
  ];
}
