import 'package:alias/features/feature_play/presentation/bloc/alias_play_bloc.dart';
import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AliasPlaySessionArea extends StatelessWidget {
  final Widget child;

  const AliasPlaySessionArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   create: (_) => AliasPlayBloc(preGameConfig: AliasPreGameConfig.initial()),
    //   child: child,
    // );
    return child;
  }
}
