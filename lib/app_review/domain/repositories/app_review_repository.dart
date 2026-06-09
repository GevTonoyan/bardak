/// Handles store review actions (listing, in-app prompt).
abstract interface class AppReviewRepository {
  /// Opens the App Store / Play Store listing for this app.
  Future<void> openStoreListing();
}
