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
