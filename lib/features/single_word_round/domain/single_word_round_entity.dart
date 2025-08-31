class SingleWordRoundEntity {
  SingleWordRoundEntity({
    required this.roundDuration,
    required this.allowSkipping,
    required this.penaltyForSkipping,
  });

  final int roundDuration;
  final bool allowSkipping;
  final bool penaltyForSkipping;
}
