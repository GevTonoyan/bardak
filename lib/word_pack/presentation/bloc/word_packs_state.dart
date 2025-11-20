part of 'word_packs_bloc.dart';

/// States for Alias Word Packs screen.
sealed class WordPacksState {
  const WordPacksState();
}

/// Initial loading state.
class WordPacksInitial extends WordPacksState {}

/// State when word packs are successfully loaded.
class WordPacksLoaded extends WordPacksState {
  const WordPacksLoaded({required this.packs, required this.selectedPackId});

  final List<AliasWordPackInfoEntity> packs;
  final String? selectedPackId;

  WordPacksLoaded copyWith({
    List<AliasWordPackInfoEntity>? packs,
    String? selectedPackId,
  }) {
    return WordPacksLoaded(
      packs: packs ?? this.packs,
      selectedPackId: selectedPackId ?? this.selectedPackId,
    );
  }
}

/// Error state when loading word packs fails.
class WordPacksError extends WordPacksState {
  const WordPacksError(this.message);

  final String message;
}
