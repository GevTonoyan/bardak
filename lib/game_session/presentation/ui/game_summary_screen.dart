import 'dart:math' as math;
import 'dart:math';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/highlighted_text.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
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
          ScreenBackground(
            shadowHeight: 200,
            child: Container(),
          ),
          Align(
            alignment: .topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: math.pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 15,
              emissionFrequency: 0.05,
              numberOfParticles: 75,
              createParticlePath: _drawStar,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 44),
              child: Column(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .start,
                children: [
                  AppIconButton.close(onTap: () => context.pop()),
                  Column(
                    children: [
                      Center(
                        child: Column(
                          spacing: 16,
                          children: [
                            Text(
                              'Հաղթեց՝',
                              style: typography.regular24.copyWith(
                                color: colors.white,
                              ),
                            ),
                            HighlightedText(text: widget.winningTeamName),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppButton(
                    label: 'Շարունակել',
                    color: colors.green,
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
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
