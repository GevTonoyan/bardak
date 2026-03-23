import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:equatable/equatable.dart';

/// Default themes every user owns before preferences are loaded.
const defaultOwnedThemes = <AppColorScheme>[.main, .blue, .black];

class ThemesState extends Equatable {
  const ThemesState({required this.purchasedThemes});

  final List<AppColorScheme> purchasedThemes;

  bool isOwned(AppColorScheme theme) => purchasedThemes.contains(theme);

  ThemesState copyWith({List<AppColorScheme>? purchasedThemes}) {
    return ThemesState(
      purchasedThemes: purchasedThemes ?? this.purchasedThemes,
    );
  }

  @override
  List<Object> get props => [purchasedThemes];
}
