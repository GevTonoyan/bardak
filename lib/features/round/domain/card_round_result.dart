class CardRoundResult {
  const CardRoundResult({required this.guessedCount, required this.seenWords});

  final int guessedCount;
  final Set<String> seenWords;

  @override
  String toString() {
    return 'CardRoundResult{guessedCount: $guessedCount, '
        'seenWords: $seenWords}';
  }
}
