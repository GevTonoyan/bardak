import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:equatable/equatable.dart';

sealed class SpyPacksState extends Equatable {
  const SpyPacksState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any packs are loaded.
class SpyPacksInitial extends SpyPacksState {
  const SpyPacksInitial();
}

/// State when spy packs are successfully loaded.
class SpyPacksLoaded extends SpyPacksState {
  const SpyPacksLoaded({required this.packs});

  final List<SpyPackEntity> packs;

  @override
  List<Object?> get props => [packs];
}

/// State when nothing is cached; shows placeholder packs that need a download.
///
/// [customPacks] (player-created) are always playable and shown first, even
/// while the built-in [fallbackPacks] still need downloading.
class SpyPacksNotCached extends SpyPacksState {
  const SpyPacksNotCached({
    required this.fallbackPacks,
    this.customPacks = const [],
  });

  final List<SpyPackEntity> fallbackPacks;
  final List<SpyPackEntity> customPacks;

  @override
  List<Object?> get props => [fallbackPacks, customPacks];
}

/// State when a session is built and the game is ready to start.
///
/// Keeps [packs] so the pack list stays rendered while navigating.
class SpyGameReady extends SpyPacksState {
  const SpyGameReady({required this.packs, required this.session});

  final List<SpyPackEntity> packs;
  final SpySessionEntity session;

  @override
  List<Object?> get props => [packs, session];
}
