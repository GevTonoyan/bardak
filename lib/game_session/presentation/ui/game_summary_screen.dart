import 'dart:math';

import 'package:bardak/app_review/presentation/bloc/in_app_review_bloc.dart';
import 'package:bardak/app_review/presentation/bloc/in_app_review_event.dart';
import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/highlighted_text.dart';
import 'package:bardak/app_ui/widgets/screen_background.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:bardak/utils/extensions/state_extension.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameSummaryScreen extends StatefulWidget {
  const GameSummaryScreen({required this.winningTeamName, super.key});

  static const routePath = 'game_summary';

  final String winningTeamName;

  @override
  State<GameSummaryScreen> createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends State<GameSummaryScreen> {
  late final ConfettiController _controller = ConfettiController(
    duration: const Duration(seconds: 6),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();
      context.read<InAppReviewBloc>().add(const InAppReviewRequested());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          GradientBackground(child: Container()),
          Align(
            alignment: .topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 15,
              emissionFrequency: 0.05,
              numberOfParticles: 75,
              createParticlePath: _drawStar,
            ),
          ),
          Column(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .start,
            children: [
              const SafeArea(bottom: false, child: SizedBox.shrink()),
              Padding(
                padding: const .symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        spacing: 16,
                        children: [
                          Text(
                            context.l10n.winner_reveal,
                            textAlign: .center,
                            style: typography.regular24,
                          ),
                          HighlightedText(text: widget.winningTeamName),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: AppButton(
                      label: context.l10n.proceed,
                      color: colors.green,
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// This code was taken from confetti official documentation example
  /// https://pub.dev/packages/confetti/example
  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path
        ..lineTo(
          halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step),
        )
        ..lineTo(
          halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep),
        );
    }
    path.close();
    return path;
  }
}
