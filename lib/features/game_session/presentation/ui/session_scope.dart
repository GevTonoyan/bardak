import 'package:boardify/features/pre_game/domain/entities/alias_pre_game_config.dart';
import 'package:flutter/material.dart';

class SessionScope extends InheritedWidget {
  final AliasPreGameEntity preGameEntity;

  const SessionScope({
    super.key,
    required this.preGameEntity,
    required super.child,
  });

  static SessionScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SessionScope>()!;

  @override
  bool updateShouldNotify(SessionScope oldWidget) => false;
}
