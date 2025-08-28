class CardRoundResult {
  final int guessedCount;
  final Set<String> seenWords;

  const CardRoundResult({required this.guessedCount, required this.seenWords});

  @override
  String toString() {
    return 'CardRoundResult{guessedCount: $guessedCount, seenWords: $seenWords}';
  }
}
