import 'dart:async';
import 'dart:math' as math;

import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RewardItem extends StatefulWidget {
  const RewardItem({
    required this.onTap,
    required this.isFront,
    this.coins,
    super.key,
  });

  final VoidCallback onTap;
  final bool isFront;
  final int? coins;

  @override
  State<RewardItem> createState() => _RewardItemState();
}

class _RewardItemState extends State<RewardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late bool _isFront = widget.isFront;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _toggleCard() async {
    if (_isFront) {
      await _controller.forward();
      setState(() {
        _isFront = !_isFront;
        widget.onTap.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO(Gevorg): optimize widget tree, too many Transforms
    // TODO(Gevorg): Reuse FlipWidget
    return Center(
      child: GestureDetector(
        onTap: _toggleCard,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, _) {
            return Stack(
              children: [
                Transform(
                  transform: Matrix4.rotationY(_animation.value * math.pi),
                  alignment: Alignment.center,
                  child: _isFront && _animation.value < 0.5
                      ? const _FrontCard()
                      : Transform.scale(
                          scaleX: -1,
                          child: Transform.scale(
                            scaleX: -1,
                            scaleY: 1,
                            child: const _BackCard(),
                          ),
                        ),
                ),
                if (widget.coins != null)
                  Center(
                    child: Transform.rotate(
                      angle: 9.25 * math.pi / 180,
                      child: Text(
                        widget.coins!.toString(),
                        style: context.typography.regular28.copyWith(
                          fontFamily: 'Digitalt',
                          color: context.colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FrontCard extends StatefulWidget {
  const _FrontCard();

  @override
  State<_FrontCard> createState() => _FrontCardState();
}

class _FrontCardState extends State<_FrontCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RotationTransition(
            turns: _controller,
            child: Assets.icons.shiner.svg(),
          ),
          Center(child: Assets.icons.question.svg(width: 16, height: 42)),
        ],
      ),
    );
  }
}

class _BackCard extends StatelessWidget {
  const _BackCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Assets.icons.rewardOpened.svg(),
    );
  }
}
