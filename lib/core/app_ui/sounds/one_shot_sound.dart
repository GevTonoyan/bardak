import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

/// Plays a short sound effect that must outlive the widget that triggered it.
///
/// Some effects fire at the exact moment the screen navigates away (the round
/// countdown "go", the timer running out), so a widget-owned [AudioPlayer]
/// would be disposed mid-clip and cut the sound off. This helper gives each
/// clip its own player that releases itself once playback finishes, decoupled
/// from any widget lifecycle.
///
/// Callers are responsible for honouring the user's sound setting before
/// calling this — it always plays.
Future<void> playOneShotSound(String assetPath) async {
  final player = AudioPlayer();
  StreamSubscription<void>? completeSub;
  Timer? safetyTimer;

  Future<void> cleanUp() async {
    safetyTimer?.cancel();
    await completeSub?.cancel();
    await player.dispose();
  }

  // The subscription closure keeps [player] alive until the clip finishes.
  completeSub = player.onPlayerComplete.listen((_) => unawaited(cleanUp()));
  // Fallback in case the platform never reports completion; our effects are
  // all well under three seconds.
  safetyTimer = Timer(const Duration(seconds: 3), () => unawaited(cleanUp()));

  try {
    await player.setReleaseMode(ReleaseMode.release);
    await player.play(AssetSource(assetPath));
  } on Object catch (error, stackTrace) {
    log(
      'Failed to play one-shot sound $assetPath',
      error: error,
      stackTrace: stackTrace,
    );
    await cleanUp();
  }
}
