import 'package:boardify/features/pre_game/domain/entities/alias_pre_game_config.dart';
import 'package:flutter/material.dart';

class SessionScope extends InheritedWidget {
  const SessionScope({
    required this.preGameEntity,
    required super.child,
    super.key,
  });

  final AliasPreGameEntity preGameEntity;

  static SessionScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SessionScope>()!;

  @override
  bool updateShouldNotify(SessionScope oldWidget) => false;
}
