part of 'word_packs_bloc.dart';

/// States for Alias Word Packs screen.
sealed class WordPacksState extends Equatable {
  const WordPacksState();
}

/// Initial loading state.
class WordPacksInitial extends WordPacksState {
  const WordPacksInitial();

  @override
  List<Object?> get props => [];
}

/// State when word packs are successfully loaded.
class WordPacksLoaded extends WordPacksState {
  const WordPacksLoaded({required this.packs, required this.locale});

  final List<WordPackEntity> packs;
  final String locale;

  WordPacksLoaded copyWith({
    List<WordPackEntity>? packs,
    String? locale,
  }) {
    return WordPacksLoaded(
      packs: packs ?? this.packs,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [packs, locale];
}

class WordPacksNotCached extends WordPacksState {
  const WordPacksNotCached({required this.fallbackPacks, required this.locale});

  final List<WordPackEntity> fallbackPacks;
  final String locale;

  @override
  List<Object?> get props => [fallbackPacks, locale];
}

/// Error state when loading word packs fails.
class WordPacksError extends WordPacksState {
  const WordPacksError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
