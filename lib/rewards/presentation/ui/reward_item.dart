import 'dart:async';

import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RewardItem extends StatefulWidget {
  const RewardItem({super.key});

  @override
  State<RewardItem> createState() => _RewardItemState();
}

class _RewardItemState extends State<RewardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  var _isFront = true;

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

  void _toggleCard() {
    if (_isFront) {
      unawaited(_controller.forward());
    } else {
      unawaited(_controller.reverse());
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleCard,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, _) {
            return Transform(
              transform: Matrix4.rotationY(_animation.value * 3.14159),
              alignment: Alignment.center,
              child: _animation.value < 0.5
                  ? const _FrontCard()
                  : Transform.scale(
                      scaleX: -1,
                      scaleY: 1,
                      child: const _BackCard(),
                    ),
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
            child: Assets.shiner.svg(),
          ),
          Center(child: Assets.question.svg(width: 16, height: 42)),
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
      child: Assets.rewardOpened.svg(),
    );
  }
}
