import 'package:equatable/equatable.dart';

sealed class InAppReviewState extends Equatable {
  const InAppReviewState();

  @override
  List<Object?> get props => [];
}

final class InAppReviewInitial extends InAppReviewState {
  const InAppReviewInitial();
}
