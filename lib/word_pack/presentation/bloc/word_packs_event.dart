part of 'word_packs_bloc.dart';

/// Events related to Alias Word Packs.
sealed class WordPacksEvent {
  const WordPacksEvent();
}

/// Loads all available word packs from the local cache.
class LoadWordPacks extends WordPacksEvent {
  const LoadWordPacks(this.locale);

  final String locale;
}

/// Fetch all packs
class CacheWordPacksIfNeeded extends WordPacksEvent {
  const CacheWordPacksIfNeeded();
}

class FetchAndCachePacks extends WordPacksEvent {
  FetchAndCachePacks({required this.locale});

  final String locale;
}
