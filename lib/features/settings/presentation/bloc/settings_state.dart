import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({required this.appSettings});

  final AppSettingsEntity appSettings;

  @override
  List<Object?> get props => [appSettings];
}
