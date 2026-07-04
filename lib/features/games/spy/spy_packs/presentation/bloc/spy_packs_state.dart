import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
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

/// State when packs could not be loaded (no cache and download failed).
class SpyPacksFailure extends SpyPacksState {
  const SpyPacksFailure();
}
