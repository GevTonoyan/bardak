import 'package:bardak/utils/constants/constants.dart';
import 'package:in_app_review/in_app_review.dart';

abstract interface class AppReviewDataSource {
  Future<void> openStoreListing();
}

class AppReviewDataSourceImpl implements AppReviewDataSource {
  AppReviewDataSourceImpl({InAppReview? inAppReview})
    : _inAppReview = inAppReview ?? InAppReview.instance;

  final InAppReview _inAppReview;

  @override
  Future<void> openStoreListing() =>
      _inAppReview.openStoreListing(appStoreId: AppConstants.appStoreId);
}
