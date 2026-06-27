import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/domain/usecases/update_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_event.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  ThemesBloc({
    required this.getPurchasedThemesUseCase,
    required this.updatePurchasedThemesUseCase,
  }) : super(const ThemesState(purchasedThemes: defaultOwnedThemes)) {
    on<LoadPurchasedThemes>(_onLoadPurchasedThemes);
    on<PurchaseTheme>(_onPurchaseTheme);

    // Load persisted themes immediately on construction.
    add(const LoadPurchasedThemes());
  }

  final GetPurchasedThemesUseCase getPurchasedThemesUseCase;
  final UpdatePurchasedThemesUseCase updatePurchasedThemesUseCase;

  void _onLoadPurchasedThemes(
    LoadPurchasedThemes event,
    Emitter<ThemesState> emit,
  ) {
    final themes = getPurchasedThemesUseCase();
    emit(ThemesState(purchasedThemes: themes));
  }

  Future<void> _onPurchaseTheme(
    PurchaseTheme event,
    Emitter<ThemesState> emit,
  ) async {
    final current = state.purchasedThemes;
    if (current.contains(event.theme)) return;

    final updated = List<AppColorScheme>.of(current)..add(event.theme);
    emit(ThemesState(purchasedThemes: updated));
    await updatePurchasedThemesUseCase(updated);
  }
}
