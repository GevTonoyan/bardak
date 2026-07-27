import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SpyPacksEvent extends Equatable {
  const SpyPacksEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the spy packs for the given locale, downloading them when the
/// cache is missing or stale.
class LoadSpyPacks extends SpyPacksEvent {
  const LoadSpyPacks(this.locale);

  final String locale;

  @override
  List<Object?> get props => [locale];
}

/// Downloads spy packs for every supported locale that is missing or stale.
class SyncSpyPacks extends SpyPacksEvent {
  const SyncSpyPacks();
}

/// Downloads the spy packs for the given locale, then reloads them.
class DownloadSpyPacks extends SpyPacksEvent {
  const DownloadSpyPacks(this.locale);

  final String locale;

  @override
  List<Object?> get props => [locale];
}

/// Draws a secret from [pack] and builds a session with current settings.
class StartSpyGame extends SpyPacksEvent {
  const StartSpyGame({required this.pack, required this.locale});

  final SpyPackEntity pack;
  final String locale;

  @override
  List<Object?> get props => [pack, locale];
}

/// Creates ([id] null) or updates a player-created pack, then reloads.
class SaveSpyPack extends SpyPacksEvent {
  const SaveSpyPack({
    required this.name,
    required this.words,
    required this.locale,
    this.id,
  });

  final String? id;
  final String name;
  final List<String> words;
  final String locale;

  @override
  List<Object?> get props => [id, name, words, locale];
}

/// Deletes a player-created pack by [id], then reloads.
class DeleteSpyPack extends SpyPacksEvent {
  const DeleteSpyPack({required this.id, required this.locale});

  final String id;
  final String locale;

  @override
  List<Object?> get props => [id, locale];
}
