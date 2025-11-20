part of 'single_word_round_bloc.dart';

enum WordResolution { guessed, skipped }

sealed class SingleWordRoundEvent {
  const SingleWordRoundEvent();
}

class ResolveCurrentWord extends SingleWordRoundEvent {
  const ResolveCurrentWord(this.resolution);

  final WordResolution resolution;
}

class CompleteRoundRequested extends SingleWordRoundEvent {
  const CompleteRoundRequested();
}
