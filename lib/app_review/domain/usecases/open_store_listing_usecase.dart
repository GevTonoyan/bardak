import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class OpenStoreListingUseCase {
  const OpenStoreListingUseCase(this._repository);

  final AppReviewRepository _repository;

  Future<void> call() => _repository.openStoreListing();
}
