import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/features/settings/domain/repositories/settings_repository.dart';
import 'package:bardak/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_color_scheme_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_locale_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_sound_enabled_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;

  setUp(() => repository = _MockSettingsRepository());

  test('GetAppSettingsUseCase returns the repository settings', () {
    final settings = AppSettingsEntity.defaultSettings();
    when(() => repository.getAppSettings()).thenReturn(settings);

    expect(GetAppSettingsUseCase(repository)(), settings);
  });

  test('UpdateLocaleUseCase persists the locale', () async {
    when(
      () => repository.updateLocale(AppLocale.ru),
    ).thenAnswer((_) async => true);

    expect(await UpdateLocaleUseCase(repository)(AppLocale.ru), isTrue);
    verify(() => repository.updateLocale(AppLocale.ru)).called(1);
  });

  test('UpdateColorSchemeUseCase persists the scheme', () async {
    when(
      () => repository.updateColorScheme(AppColorScheme.purple),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateColorSchemeUseCase(repository)(AppColorScheme.purple),
      isTrue,
    );
    verify(() => repository.updateColorScheme(AppColorScheme.purple)).called(1);
  });

  test('UpdateSoundEnabledUseCase persists the flag', () async {
    when(
      () => repository.updateSoundEnabled(soundEnabled: false),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateSoundEnabledUseCase(repository)(soundEnabled: false),
      isTrue,
    );
    verify(() => repository.updateSoundEnabled(soundEnabled: false)).called(1);
  });
}
