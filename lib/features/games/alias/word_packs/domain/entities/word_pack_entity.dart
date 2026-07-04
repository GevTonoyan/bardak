import 'package:equatable/equatable.dart';

/// Describes a single word pack with its ID, name, words and cover image.
class WordPackEntity extends Equatable {
  const WordPackEntity({
    required this.id,
    required this.name,
    required this.words,
    required this.image,
    required this.imageBlurHash,
  });

  /// Creates a [WordPackEntity] from a JSON map (e.g. a Firestore doc).
  factory WordPackEntity.fromJson(String id, Map<String, dynamic> json) {
    return WordPackEntity(
      id: id,
      name: json[_nameKey] as String,
      words: List<String>.from(json[_wordsKey] as List? ?? const []),
      image: json[_imageKey] as String,
      imageBlurHash: json[_imageBlurHashKey] as String,
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

  @override
  List<Object> get props => [id, name, words, image, imageBlurHash];
}
