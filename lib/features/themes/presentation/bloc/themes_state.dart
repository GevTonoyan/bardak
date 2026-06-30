import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:equatable/equatable.dart';

enum ThemesStatus { idle, purchasing, purchaseSuccess, insufficientFunds }

class ThemesState extends Equatable {
  const ThemesState({
    required this.purchasedThemes,
    this.status = ThemesStatus.idle,
    this.lastPurchased,
  });

  final List<AppColorScheme> purchasedThemes;
  final ThemesStatus status;

  /// The most recently purchased theme, used to apply it after a purchase.
  final AppColorScheme? lastPurchased;

  bool isOwned(AppColorScheme theme) => purchasedThemes.contains(theme);

  ThemesState copyWith({
    List<AppColorScheme>? purchasedThemes,
    ThemesStatus? status,
    AppColorScheme? lastPurchased,
  }) {
    return ThemesState(
      purchasedThemes: purchasedThemes ?? this.purchasedThemes,
      status: status ?? this.status,
      lastPurchased: lastPurchased ?? this.lastPurchased,
    );
  }

  @override
  List<Object?> get props => [purchasedThemes, status, lastPurchased];
}
