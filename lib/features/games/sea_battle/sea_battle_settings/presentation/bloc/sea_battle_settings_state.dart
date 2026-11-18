import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SeaBattleSettingsState extends Equatable {
  const SeaBattleSettingsState({required this.seaBattleSettings});

  final SeaBattleSettingsEntity seaBattleSettings;

  @override
  List<Object?> get props => [seaBattleSettings];
}
