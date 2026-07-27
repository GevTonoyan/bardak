import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/are_spy_packs_cached_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/delete_custom_spy_pack_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/download_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/draw_spy_secret_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_custom_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_fallback_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/save_custom_spy_pack_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSpyPacksRepository extends Mock implements SpyPacksRepository {}

const _pack = SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: ['Beach'],
  image: '',
  imageBlurHash: '',
);

void main() {
  late _MockSpyPacksRepository repository;

  setUpAll(() => registerFallbackValue(_pack));

  setUp(() => repository = _MockSpyPacksRepository());

  test('GetSpyPacksUseCase returns the cached packs', () async {
    when(() => repository.getSpyPacks('en')).thenAnswer((_) async => [_pack]);

    expect(await GetSpyPacksUseCase(repository)('en'), [_pack]);
  });

  test('GetFallbackSpyPacksUseCase returns the placeholders', () {
    when(() => repository.getFallbackSpyPacks('en')).thenReturn([_pack]);

    expect(GetFallbackSpyPacksUseCase(repository)('en'), [_pack]);
  });

  test('AreSpyPacksCachedUseCase queries the cache state', () async {
    when(
      () => repository.areSpyPacksCached('ru'),
    ).thenAnswer((_) async => true);

    expect(await AreSpyPacksCachedUseCase(repository)('ru'), isTrue);
  });

  test('DownloadSpyPacksUseCase downloads for the locale', () async {
    when(() => repository.downloadSpyPacks('am')).thenAnswer((_) async {});

    await DownloadSpyPacksUseCase(repository)('am');

    verify(() => repository.downloadSpyPacks('am')).called(1);
  });

  test('DrawSpySecretUseCase draws from the given pack and locale', () async {
    when(
      () => repository.drawSecret(localeCode: 'en', pack: _pack),
    ).thenAnswer((_) async => 'Beach');

    final secret = await DrawSpySecretUseCase(repository)(
      const DrawSpySecretParams(localeCode: 'en', pack: _pack),
    );

    expect(secret, 'Beach');
  });

  test('GetCustomSpyPacksUseCase returns the custom packs', () async {
    when(repository.getCustomSpyPacks).thenAnswer((_) async => [_pack]);

    expect(await GetCustomSpyPacksUseCase(repository)(), [_pack]);
  });

  test('SaveCustomSpyPackUseCase creates a custom pack with a new id', () async {
    when(() => repository.saveCustomSpyPack(any())).thenAnswer((_) async {});

    await SaveCustomSpyPackUseCase(repository)(
      const SaveCustomSpyPackParams(name: 'Friends', words: ['A', 'B', 'C']),
    );

    final saved =
        verify(() => repository.saveCustomSpyPack(captureAny())).captured.single
            as SpyPackEntity;
    expect(saved.isCustom, isTrue);
    expect(saved.name, 'Friends');
    expect(saved.words, ['A', 'B', 'C']);
    expect(saved.id, startsWith('custom_'));
  });

  test('SaveCustomSpyPackUseCase keeps the id when editing', () async {
    when(() => repository.saveCustomSpyPack(any())).thenAnswer((_) async {});

    await SaveCustomSpyPackUseCase(repository)(
      const SaveCustomSpyPackParams(
        id: 'custom_42',
        name: 'Friends',
        words: ['A', 'B', 'C'],
      ),
    );

    final saved =
        verify(() => repository.saveCustomSpyPack(captureAny())).captured.single
            as SpyPackEntity;
    expect(saved.id, 'custom_42');
  });

  test('DeleteCustomSpyPackUseCase deletes by id', () async {
    when(
      () => repository.deleteCustomSpyPack('custom_1'),
    ).thenAnswer((_) async {});

    await DeleteCustomSpyPackUseCase(repository)('custom_1');

    verify(() => repository.deleteCustomSpyPack('custom_1')).called(1);
  });
}
