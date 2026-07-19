import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_color_scheme_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_locale_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_sound_enabled_usecase.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetAppSettings extends Mock implements GetAppSettingsUseCase {}

class _MockUpdateLocale extends Mock implements UpdateLocaleUseCase {}

class _MockUpdateColorScheme extends Mock implements UpdateColorSchemeUseCase {}

class _MockUpdateSoundEnabled extends Mock
    implements UpdateSoundEnabledUseCase {}

class _MockOpenStoreListing extends Mock implements OpenStoreListingUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(AppColorScheme.main);
    registerFallbackValue(AppLocale.en);
  });

  late _MockGetAppSettings getAppSettings;
  late _MockUpdateLocale updateLocale;
  late _MockUpdateColorScheme updateColorScheme;
  late _MockUpdateSoundEnabled updateSoundEnabled;
  late _MockOpenStoreListing openStoreListing;

  setUp(() {
    getAppSettings = _MockGetAppSettings();
    updateLocale = _MockUpdateLocale();
    updateColorScheme = _MockUpdateColorScheme();
    updateSoundEnabled = _MockUpdateSoundEnabled();
    openStoreListing = _MockOpenStoreListing();
  });

  SettingsBloc buildBloc() => SettingsBloc(
    getAppSettingsUseCase: getAppSettings,
    updateLocaleUseCase: updateLocale,
    updateColorSchemeUseCase: updateColorScheme,
    updateSoundEnabledUseCase: updateSoundEnabled,
    openStoreListingUseCase: openStoreListing,
  );

  test(
    'LoadAppSettings replaces the defaults with persisted settings',
    () async {
      final persisted = AppSettingsEntity.defaultSettings().copyWith(
        locale: AppLocale.ru,
        soundEnabled: false,
      );
      when(getAppSettings.call).thenReturn(persisted);

      final bloc = buildBloc()..add(const LoadAppSettings());
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state.appSettings, persisted);
    },
  );

  test('ChangeColorScheme persists and applies the scheme', () async {
    when(
      () => updateColorScheme(AppColorScheme.purple),
    ).thenAnswer((_) async => true);

    final bloc = buildBloc()
      ..add(const ChangeColorScheme(colorScheme: AppColorScheme.purple));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.appSettings.colorScheme, AppColorScheme.purple);
    verify(() => updateColorScheme(AppColorScheme.purple)).called(1);
  });

  test('ChangeColorScheme to the current scheme is a no-op', () async {
    final bloc = buildBloc()
      ..add(const ChangeColorScheme(colorScheme: AppColorScheme.main));
    addTearDown(bloc.close);
    await pumpEventQueue();

    verifyNever(() => updateColorScheme(any()));
  });

  test('ChangeLocale persists and applies the locale', () async {
    when(() => updateLocale(AppLocale.am)).thenAnswer((_) async => true);

    final bloc = buildBloc()..add(const ChangeLocale(AppLocale.am));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.appSettings.locale, AppLocale.am);
    verify(() => updateLocale(AppLocale.am)).called(1);
  });

  test('ChangeSoundEnabled persists and applies the flag', () async {
    when(
      () => updateSoundEnabled(soundEnabled: false),
    ).thenAnswer((_) async => true);

    final bloc = buildBloc()..add(const ChangeSoundEnabled(enabled: false));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.appSettings.soundEnabled, isFalse);
    verify(() => updateSoundEnabled(soundEnabled: false)).called(1);
  });

  test('OpenStoreListing opens the store', () async {
    when(openStoreListing.call).thenAnswer((_) async {});

    final bloc = buildBloc()..add(const OpenStoreListing());
    addTearDown(bloc.close);
    await pumpEventQueue();

    verify(openStoreListing.call).called(1);
  });
}
