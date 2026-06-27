import 'package:in_app_review/in_app_review.dart';

abstract interface class AppReviewPlatformDataSource {
  Future<void> openStoreListing();

  Future<bool> requestInAppReview();
}

class AppReviewPlatformDataSourceImpl implements AppReviewPlatformDataSource {
  AppReviewPlatformDataSourceImpl({InAppReview? inAppReview})
    : _inAppReview = inAppReview ?? InAppReview.instance;

  static const _appStoreId = '6766040587';

  final InAppReview _inAppReview;

  @override
  Future<void> openStoreListing() =>
      _inAppReview.openStoreListing(appStoreId: _appStoreId);

  @override
  Future<bool> requestInAppReview() async {
    if (!await _inAppReview.isAvailable()) {
      return false;
    }

    await _inAppReview.requestReview();
    return true;
  }
}
