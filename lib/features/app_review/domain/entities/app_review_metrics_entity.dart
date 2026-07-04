import 'package:equatable/equatable.dart';

class AppReviewMetricsEntity extends Equatable {
  const AppReviewMetricsEntity({
    required this.gamesCompleted,
    required this.appOpenedCount,
    this.lastReviewPromptAt,
  });

  final int gamesCompleted;
  final int appOpenedCount;
  final DateTime? lastReviewPromptAt;

  @override
  List<Object?> get props => [
    gamesCompleted,
    appOpenedCount,
    lastReviewPromptAt,
  ];
}
