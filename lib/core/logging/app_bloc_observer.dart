import 'package:bardak/core/di/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    logger.debug('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.debug('Bloc event: ${bloc.runtimeType} -> ${event.runtimeType}');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    logger.debug(
      'Bloc transition: ${bloc.runtimeType} -> '
      '${transition.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.error(
      'Bloc error in ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    logger.debug('Bloc closed: ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
