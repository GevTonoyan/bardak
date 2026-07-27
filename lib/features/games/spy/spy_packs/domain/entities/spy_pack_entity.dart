import 'package:equatable/equatable.dart';

/// Describes a single spy pack with its ID, name, words and cover image.
class SpyPackEntity extends Equatable {
  const SpyPackEntity({
    required this.id,
    required this.name,
    required this.words,
    required this.image,
    required this.imageBlurHash,
    this.isCustom = false,
  });

  /// Creates a [SpyPackEntity] from a JSON map (e.g. a Firestore doc).
  ///
  /// The image fields are optional so packs stay usable while their
  /// artwork is not uploaded yet.
  factory SpyPackEntity.fromJson(String id, Map<String, dynamic> json) {
    return SpyPackEntity(
      id: id,
      name: json[_nameKey] as String,
      words: List<String>.from(json[_wordsKey] as List? ?? const []),
      image: json[_imageKey] as String? ?? '',
      imageBlurHash: json[_imageBlurHashKey] as String? ?? '',
    );
  }

  static const _nameKey = 'name';
  static const _wordsKey = 'words';
  static const _imageKey = 'image';
  static const _imageBlurHashKey = 'image_blur_hash';

  final String id;
  final String name;
  final List<String> words;
  final String image;
  final String imageBlurHash;

  /// True for packs the player created on-device; drives the "Yours" tile
  /// styling and edit/delete affordances.
  final bool isCustom;

  @override
  List<Object> get props => [id, name, words, image, imageBlurHash, isCustom];
}
