import 'package:equatable/equatable.dart';

/// Describes a single word pack with its ID, name, words and cover image.
class WordPackEntity extends Equatable {
  const WordPackEntity({
    required this.id,
    required this.name,
    required this.words,
    required this.image,
    required this.imageBlurHash,
    this.easyWords = const [],
  });

  /// Creates a [WordPackEntity] from a JSON map (e.g. a Firestore doc).
  factory WordPackEntity.fromJson(String id, Map<String, dynamic> json) {
    return WordPackEntity(
      id: id,
      name: json[_nameKey] as String,
      words: List<String>.from(json[_wordsKey] as List? ?? const []),
      easyWords: List<String>.from(json[_easyKey] as List? ?? const []),
      image: json[_imageKey] as String,
      imageBlurHash: json[_imageBlurHashKey] as String,
    );
  }

  static const _nameKey = 'name';
  static const _wordsKey = 'words';
  static const _easyKey = 'easy';
  static const _imageKey = 'image';
  static const _imageBlurHashKey = 'image_blur_hash';

  final String id;
  final String name;

  /// The full word list — every word in the pack.
  final List<String> words;

  /// The kid-safe subset, when the pack provides one. A subset of [words]
  /// conceptually; empty when the pack has no easy mode.
  final List<String> easyWords;

  final String image;
  final String imageBlurHash;

  /// Whether this pack offers an easy mode, i.e. it has easy words.
  bool get hasEasyWords => easyWords.isNotEmpty;

  /// The words to play for the chosen mode. In easy mode a pack without easy
  /// words has no playable words, rather than silently falling back to the
  /// full list.
  List<String> wordsFor({required bool easyMode}) {
    if (!easyMode) return words;
    return hasEasyWords ? easyWords : const [];
  }

  @override
  List<Object> get props => [
    id,
    name,
    words,
    easyWords,
    image,
    imageBlurHash,
  ];
}
