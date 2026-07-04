import 'package:equatable/equatable.dart';

/// How the player resolved the current word.
enum WordResolution { guessed, skipped }

sealed class SingleWordRoundEvent extends Equatable {
  const SingleWordRoundEvent();

  @override
  List<Object?> get props => [];
}

/// Resolves the current word and advances to the next one.
class ResolveCurrentWord extends SingleWordRoundEvent {
  const ResolveCurrentWord(this.resolution);

  final WordResolution resolution;

  @override
  List<Object?> get props => [resolution];
}

/// Ends the round (e.g. when the timer runs out).
class CompleteRound extends SingleWordRoundEvent {
  const CompleteRound();
}
