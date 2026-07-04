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
