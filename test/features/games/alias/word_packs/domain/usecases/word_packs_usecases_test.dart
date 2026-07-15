import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/download_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_fallback_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_word_packs_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWordPacksRepository extends Mock implements WordPacksRepository {}

const _pack = WordPackEntity(
  id: 'animals',
  name: 'Animals',
  words: ['Cat'],
  image: '',
  imageBlurHash: '',
);

void main() {
  late _MockWordPacksRepository repository;

  setUp(() => repository = _MockWordPacksRepository());

  test('GetWordPacksUseCase returns the cached packs', () async {
    when(() => repository.getWordPacks('en')).thenAnswer((_) async => [_pack]);

    expect(await GetWordPacksUseCase(repository)('en'), [_pack]);
  });

  test('GetFallbackWordPacksUseCase returns the placeholders', () {
    when(() => repository.getFallbackWordPacks('en')).thenReturn([_pack]);

    expect(GetFallbackWordPacksUseCase(repository)('en'), [_pack]);
  });

  test('AreWordPacksCachedUseCase queries the cache state', () async {
    when(
      () => repository.areWordPacksCached('ru'),
    ).thenAnswer((_) async => false);

    expect(await AreWordPacksCachedUseCase(repository)('ru'), isFalse);
  });

  test('DownloadWordPacksUseCase downloads for the locale', () async {
    when(() => repository.downloadWordPacks('am')).thenAnswer((_) async {});

    await DownloadWordPacksUseCase(repository)('am');

    verify(() => repository.downloadWordPacks('am')).called(1);
  });
}
