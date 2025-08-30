part of 'alias_word_packs_bloc.dart';

/// Events related to Alias Word Packs.
sealed class AliasWordPacksEvent {
  const AliasWordPacksEvent();
}

/// Loads all available word packs from the local cache.
class LoadWordPacks extends AliasWordPacksEvent {
  const LoadWordPacks(this.localeCode);

  final String localeCode;
}

/// Sets the selected word pack ID in preferences.
class SelectWordPack extends AliasWordPacksEvent {
  const SelectWordPack({required this.packId, required this.localeCode});

  final String packId;
  final String localeCode;
}
