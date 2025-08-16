part of 'alias_word_packs_bloc.dart';

/// States for Alias Word Packs screen.
sealed class AliasWordPacksState {
  const AliasWordPacksState();
}

/// Initial loading state.
class AliasWordPacksInitial extends AliasWordPacksState {}

/// State when word packs are successfully loaded.
class AliasWordPacksLoaded extends AliasWordPacksState {
  final List<AliasWordPackInfoEntity> packs;
  final String? selectedPackId;

  const AliasWordPacksLoaded({required this.packs, required this.selectedPackId});

  AliasWordPacksLoaded copyWith({List<AliasWordPackInfoEntity>? packs, String? selectedPackId}) {
    return AliasWordPacksLoaded(
      packs: packs ?? this.packs,
      selectedPackId: selectedPackId ?? this.selectedPackId,
    );
  }
}

/// Error state when loading word packs fails.
class AliasWordPacksError extends AliasWordPacksState {
  final String message;

  const AliasWordPacksError(this.message);
}
