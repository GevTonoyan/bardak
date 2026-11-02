import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Why the app could not finish starting up.
class StartupFailure implements Exception {
  const StartupFailure({
    required this.step,
    required this.error,
    required this.stackTrace,
  });

  final String step;
  final Object error;
  final StackTrace stackTrace;

  String get report => 'Step: $step\nError: $error\n\n$stackTrace';

  @override
  String toString() => 'StartupFailure($step): $error';
}

/// Surfaces startup errors on screen instead of leaving the app frozen on
/// the splash screen. Release builds (TestFlight, App Store) print nothing
/// we can read, so the failure is rendered by `StartupGate`.
abstract final class StartupGuard {
  static const _stepTimeout = Duration(seconds: 15);
  static const _watchdogTimeout = Duration(seconds: 25);

  /// The first failure reported before [markCompleted]; `null` while healthy.
  static final failure = ValueNotifier<StartupFailure?>(null);

  static bool _completed = false;
  static String _lastStep = 'main';
  static Timer? _watchdog;

  /// Hooks the global error handlers and starts the startup watchdog.
  static void install() {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      previousOnError?.call(details);
      _report(
        'Flutter error (after: $_lastStep)',
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      _report('Uncaught error (after: $_lastStep)', error, stackTrace);
      return true;
    };
    _watchdog = Timer(_watchdogTimeout, () {
      _report(
        'Watchdog',
        TimeoutException(
          'Startup did not finish. Last step reached: $_lastStep',
          _watchdogTimeout,
        ),
        StackTrace.current,
      );
    });
  }

  /// Runs one startup [action]; throws [StartupFailure] naming the step if
  /// it fails or does not finish within [_stepTimeout].
  static Future<T> step<T>(String name, FutureOr<T> Function() action) async {
    mark(name);
    try {
      return await Future.sync(action).timeout(_stepTimeout);
    } on Object catch (error, stackTrace) {
      throw StartupFailure(step: name, error: error, stackTrace: stackTrace);
    }
  }

  /// Records progress so the watchdog can tell where startup stopped.
  static void mark(String step) {
    _lastStep = step;
    log('Startup step: $step', name: 'STARTUP');
  }

  /// Called once the first real screen is reached.
  static void markCompleted() {
    _completed = true;
    _watchdog?.cancel();
    mark('completed');
  }

  static void fail(StartupFailure startupFailure) {
    _report(
      startupFailure.step,
      startupFailure.error,
      startupFailure.stackTrace,
    );
  }

  static void _report(String step, Object error, StackTrace stackTrace) {
    log(
      'Startup failure in $step',
      name: 'STARTUP',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
    if (_completed || failure.value != null) return;
    _watchdog?.cancel();
    failure.value = StartupFailure(
      step: step,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
