import 'package:bardak/app_review/data/data_sources/app_review_data_source.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';

class AppReviewRepositoryImpl implements AppReviewRepository {
  const AppReviewRepositoryImpl({required this.dataSource});

  final AppReviewDataSource dataSource;

  @override
  Future<void> openStoreListing() => dataSource.openStoreListing();
}
