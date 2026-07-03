import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:equatable/equatable.dart';

sealed class WordPacksState extends Equatable {
  const WordPacksState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any packs are loaded.
class WordPacksInitial extends WordPacksState {
  const WordPacksInitial();
}

/// State when word packs are successfully loaded from the cache.
class WordPacksLoaded extends WordPacksState {
  const WordPacksLoaded({required this.packs});

  final List<WordPackEntity> packs;

  @override
  List<Object?> get props => [packs];
}

/// State when nothing is cached; shows fallback packs that need a download.
class WordPacksNotCached extends WordPacksState {
  const WordPacksNotCached({required this.fallbackPacks});

  final List<WordPackEntity> fallbackPacks;

  @override
  List<Object?> get props => [fallbackPacks];
}
