import 'package:bardak/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

ModalBottomSheetRoute<T> buildAppBottomSheet<T>({
  required BuildContext context,
  required Page<T> settings,

  required Widget child,
  bool isFullHeight = true,
}) {
  return ModalBottomSheetRoute<T>(
    settings: settings,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: const BoxConstraints(maxWidth: double.maxFinite),
    transitionAnimationController: context.bottomSheetAnimationController(),
    backgroundColor: Colors.transparent,
    modalBarrierColor: context.colors.secondary.withValues(alpha: 0.5),
    builder: (_) => child,
  );
}

class ScaffoldBottomSheet extends StatelessWidget {
  const ScaffoldBottomSheet({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      title,
                      style: context.typography.regular24,
                    ),
                  ),
                  AppIconButton.back(onTap: () => context.pop()),
                ],
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class FullBottomSheet extends StatelessWidget {
  const FullBottomSheet({
    required this.titleBuilder,
    required this.child,
    super.key,
  });

  final String Function(BuildContext) titleBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondary,
      borderRadius: const .vertical(top: .circular(30)),
      child: SafeArea(
        child: Padding(
          padding: const .all(20),
          child: Column(
            mainAxisSize: .min,
            children: [
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        titleBuilder(context),
                        style: context.typography.regular24,
                      ),
                    ),
                    AppIconButton.back(onTap: () => context.pop()),
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class PartialBottomSheet extends StatelessWidget {
  const PartialBottomSheet({
    required this.titleBuilder,
    required this.child,
    super.key,
  });

  final String Function(BuildContext) titleBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondary,
      borderRadius: const .vertical(top: .circular(30)),
      child: SafeArea(
        child: Padding(
          padding: const .all(20),
          child: Column(
            mainAxisSize: .min,
            children: [
              SizedBox(
                height: 40,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        titleBuilder(context),
                        style: context.typography.regular24,
                      ),
                    ),
                    AppIconButton.back(onTap: () => context.pop()),
                  ],
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

extension SheetAnimation on BuildContext {
  AnimationController bottomSheetAnimationController({
    Duration duration = const Duration(milliseconds: 300),
    Duration reverseDuration = const Duration(milliseconds: 500),
  }) {
    return BottomSheet.createAnimationController(
        Navigator.of(this),
      )
      ..duration = duration
      ..reverseDuration = reverseDuration;
  }
}
