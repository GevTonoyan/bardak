import 'package:equatable/equatable.dart';

/// A player in a Spy match, identified by their pass-the-phone order.
class SpyPlayerEntity extends Equatable {
  const SpyPlayerEntity({required this.number, required this.isSpy});

  /// 1-based player number shown on screen ("Player 3").
  final int number;

  final bool isSpy;

  @override
  List<Object?> get props => [number, isSpy];
}
