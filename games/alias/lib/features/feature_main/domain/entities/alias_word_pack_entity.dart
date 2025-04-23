class AliasWordPackEntity {
  final String id; // e.g., "movies"
  final String name; // e.g., "🎬 Movies"
  final String emoji; // e.g., "🧩"
  final List<String> words;

  const AliasWordPackEntity({
    required this.id,
    required this.name,
    this.emoji = '🧩',
    required this.words,
  });

  /// Creates an AliasWordPackEntity from Firestore JSON-like map.
  factory AliasWordPackEntity.fromFirestore(String id, Map<String, dynamic> json) {
    return AliasWordPackEntity(
      id: id,
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '🧩',
      words: List<String>.from(json['words'] ?? const []),
    );
  }
}
