import 'package:equatable/equatable.dart';

sealed class WordPacksEvent extends Equatable {
  const WordPacksEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the word packs for the given locale from the local cache.
class LoadWordPacks extends WordPacksEvent {
  const LoadWordPacks(this.locale);

  final String locale;

  @override
  List<Object?> get props => [locale];
}

/// Downloads word packs for every supported locale that is missing or stale.
class SyncWordPacks extends WordPacksEvent {
  const SyncWordPacks();
}

/// Downloads the word packs for the given locale, then reloads them.
class DownloadWordPacks extends WordPacksEvent {
  const DownloadWordPacks(this.locale);

  final String locale;

  @override
  List<Object?> get props => [locale];
}
