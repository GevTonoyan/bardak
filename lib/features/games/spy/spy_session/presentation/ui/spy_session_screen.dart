import 'dart:async';

import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Shell around the Spy round screens keeping [SpySessionBloc] alive.
class SpySessionScreen extends StatefulWidget {
  const SpySessionScreen({
    required this.session,
    required this.child,
    super.key,
  });

  final SpySessionEntity? session;
  final Widget child;

  static const routePath = 'spySession';

  @override
  State<SpySessionScreen> createState() => _SpySessionScreenState();
}

class _SpySessionScreenState extends State<SpySessionScreen> {
  // GoRouter rebuilds the shell with a null `extra` when navigating between
  // round screens, so the first non-null session is cached for the shell's
  // lifetime.
  SpySessionEntity? _cached;

  @override
  void initState() {
    super.initState();
    _cached = widget.session;
  }

  @override
  void didUpdateWidget(covariant SpySessionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _cached ??= widget.session;
  }

  @override
  Widget build(BuildContext context) {
    final session = _cached;
    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('Missing spy session. Start a new game.')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        unawaited(
          showExitGameSheet(
            context: context,
            onConfirm: () => context.pop(),
          ),
        );
      },
      child: BlocProvider(
        create: (_) => SpySessionBloc(initialSession: session),
        child: widget.child,
      ),
    );
  }
}
