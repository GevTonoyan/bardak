import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/domain/usecases/purchase_theme_usecase.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_event.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemesBloc extends Bloc<ThemesEvent, ThemesState> {
  ThemesBloc({
    required GetPurchasedThemesUseCase getPurchasedThemesUseCase,
    required this._purchaseThemeUseCase,
  }) : super(ThemesState(purchasedThemes: getPurchasedThemesUseCase())) {
    on<PurchaseTheme>(_onPurchaseTheme);
  }

  final PurchaseThemeUseCase _purchaseThemeUseCase;

  Future<void> _onPurchaseTheme(
    PurchaseTheme event,
    Emitter<ThemesState> emit,
  ) async {
    if (state.isOwned(event.theme)) return;

    emit(state.copyWith(status: ThemesStatus.purchasing));

    try {
      final result = await _purchaseThemeUseCase(event.theme);
      switch (result) {
        case .success:
          emit(
            state.copyWith(
              purchasedThemes: [...state.purchasedThemes, event.theme],
              status: .purchaseSuccess,
              lastPurchased: event.theme,
            ),
          );
        case .insufficientFunds:
          emit(state.copyWith(status: .insufficientFunds));
      }
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to purchase theme',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(status: .idle));
    }
  }
}
