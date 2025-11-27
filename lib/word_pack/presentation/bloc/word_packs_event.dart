part of 'word_packs_bloc.dart';

/// Events related to Alias Word Packs.
sealed class WordPacksEvent {
  const WordPacksEvent();
}

/// Loads all available word packs from the local cache.
class LoadWordPacks extends WordPacksEvent {
  const LoadWordPacks(this.localeCode);

  final String localeCode;
}

/// Sets the selected word pack ID in preferences.
class SelectWordPack extends WordPacksEvent {
  const SelectWordPack({required this.packId, required this.localeCode});

  final String packId;
  final String localeCode;
}
