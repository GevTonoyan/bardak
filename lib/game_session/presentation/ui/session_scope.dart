import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:flutter/material.dart';

class SessionScope extends InheritedWidget {
  const SessionScope({
    required this.preGameEntity,
    required super.child,
    super.key,
  });

  final PreGameEntity preGameEntity;

  static SessionScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SessionScope>()!;

  @override
  bool updateShouldNotify(SessionScope oldWidget) => false;
}
