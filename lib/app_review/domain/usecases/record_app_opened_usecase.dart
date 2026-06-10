import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class RecordAppOpenedUseCase {
  const RecordAppOpenedUseCase(this.repository);

  final AppReviewRepository repository;

  Future<void> call() => repository.incrementAppOpenedCount();
}
