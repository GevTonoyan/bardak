import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'alias_play_event.dart';

part 'alias_play_state.dart';

class AliasPlayBloc extends Bloc<AliasPlayEvent, AliasPlayState> {
  final AliasPreGameConfig preGameConfig;

  AliasPlayBloc({required this.preGameConfig}) : super(const AliasPlayInitial()) {}
}
