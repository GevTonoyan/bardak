import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class OpenStoreListingUseCase {
  const OpenStoreListingUseCase(this._appReviewRepository);

  final AppReviewRepository _appReviewRepository;

  Future<void> call() => _appReviewRepository.openStoreListing();
}
