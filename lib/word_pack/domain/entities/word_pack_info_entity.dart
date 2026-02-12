import 'package:boardify/localizations/common/supported_locales.dart';
import 'package:boardify/word_pack/domain/entities/word_packs_fallbacks.dart';
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
  });

  factory WordPackEntity.fromDatabase(Map<String, dynamic> data) {
    return WordPackEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      words: data['words'] as List<String>,
    );
  }

  /// Creates an AliasWordPackEntity from Firestore JSON-like map.
  factory WordPackEntity.fromFirestore(String id, Map<String, dynamic> json) {
    return WordPackEntity(
      id: id,
      name: json['name'] as String,
      words: List<String>.from(json['words'] ?? const []),
    );
  }

  final String id;
  final String name;
  final List<String> words;

  @override
  List<Object?> get props => [id, name, words];
}
