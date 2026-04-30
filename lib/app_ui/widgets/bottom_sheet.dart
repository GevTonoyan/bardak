import 'dart:ui';

import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Route<T> buildAppBottomSheetRoute<T>({
  required BuildContext context,
  required Page<T> settings,
  required String Function(BuildContext) titleBuilder,
  required Widget child,
}) {
  return ModalBottomSheetRoute<T>(
    settings: settings,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final colors = context.appTheme.colors;
      final typography = context.appTheme.typography;

      return Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox.expand(),
            ),
          ),
          Material(
            color: colors.secondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
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
                              style: typography.regular24,
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
          ),
        ],
      );
    },
  );
}
