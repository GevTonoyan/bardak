class AliasWordPackEntity {
  const AliasWordPackEntity({
    required this.id,
    required this.name,
    required this.words,
    this.emoji = '🧩',
  });

  /// Creates an AliasWordPackEntity from Firestore JSON-like map.
  factory AliasWordPackEntity.fromFirestore(
    String id,
    Map<String, dynamic> json,
  ) {
    return AliasWordPackEntity(
      id: id,
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '🧩',
      words: List<String>.from(json['words'] ?? const []),
    );
  }

  final String id; // e.g., "movies"
  final String name; // e.g., "🎬 Movies"
  final String emoji; // e.g., "🧩"
  final List<String> words;
}
