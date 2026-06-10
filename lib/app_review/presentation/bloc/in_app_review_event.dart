import 'package:equatable/equatable.dart';

sealed class InAppReviewEvent extends Equatable {
  const InAppReviewEvent();

  @override
  List<Object?> get props => [];
}

final class InAppReviewRequested extends InAppReviewEvent {
  const InAppReviewRequested();
}
