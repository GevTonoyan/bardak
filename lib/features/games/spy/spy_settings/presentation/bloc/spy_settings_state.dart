import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SpySettingsState extends Equatable {
  const SpySettingsState({required this.spySettings});

  final SpySettingsEntity spySettings;

  @override
  List<Object?> get props => [spySettings];
}
