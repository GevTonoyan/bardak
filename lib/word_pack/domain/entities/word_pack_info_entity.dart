/// Contains the list of word packs and the currently selected pack ID.
class AliasWordPackInfoResultEntity {
  const AliasWordPackInfoResultEntity({
    required this.packs,
    required this.selectedPackId,
  });

  final List<AliasWordPackInfoEntity> packs;
  final String? selectedPackId;
}

/// Describes a single word pack with its ID, name, emoji and list of words.
class AliasWordPackInfoEntity {
  const AliasWordPackInfoEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.words,
  });

  factory AliasWordPackInfoEntity.fromDatabase(Map<String, dynamic> data) {
    return AliasWordPackInfoEntity(
      id: data['id'] as String,
      name: data['name'] as String,
      emoji: data['emoji'] as String,
      words: data['words'] as List<String>,
    );
  }

  final String id;
  final String name;
  final String emoji;
  final List<String> words;
}
