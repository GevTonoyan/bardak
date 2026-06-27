import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class RecordAppOpenedUseCase {
  const RecordAppOpenedUseCase(this._appReviewRepository);

  final AppReviewRepository _appReviewRepository;

  Future<void> call() => _appReviewRepository.incrementAppOpenedCount();
}
