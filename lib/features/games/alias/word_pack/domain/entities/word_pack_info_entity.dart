import 'package:bardak/core/localizations/common/supported_locales.dart';
import 'package:bardak/features/games/alias/word_pack/domain/entities/word_packs_fallbacks.dart';
import 'package:equatable/equatable.dart';

/// Contains the list of word packs.
class WordPackInfoResultEntity extends Equatable {
  const WordPackInfoResultEntity({required this.packs});

  factory WordPackInfoResultEntity.fallback(String locale) {
    return switch (AppLocales.fromString(locale)) {
      .en => const WordPackInfoResultEntity(packs: enPacks),
      .ru => const WordPackInfoResultEntity(packs: ruPacks),
      .am => const WordPackInfoResultEntity(packs: amPacks),
    };
  }

  final List<WordPackEntity> packs;

  @override
  List<Object?> get props => [packs];
}

/// Describes a single word pack with its ID, name, emoji and list of words.
class WordPackEntity extends Equatable {
  const WordPackEntity({
    required this.id,
    required this.name,
    required this.words,
    required this.image,
    required this.imageBlurHash,
  });

  /// Creates an AliasWordPackEntity from Firestore JSON-like map.
  factory WordPackEntity.fromFirestore(String id, Map<String, dynamic> json) {
    return WordPackEntity(
      id: id,
      name: json['name'] as String,
      words: List<String>.from(json['words'] ?? const []),
      image: json['image'] as String,
      imageBlurHash: json['image_blur_hash'] as String,
    );
  }

  final String id;
  final String name;
  final List<String> words;
  final String image;
  final String imageBlurHash;

  @override
  List<Object> get props => [id, name, words, image, imageBlurHash];
}
