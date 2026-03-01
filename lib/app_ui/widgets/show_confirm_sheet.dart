import 'dart:async';
import 'dart:ui';
import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showConfirmSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmText,
  required String cancelText,
  required Color confirmColor,
  required Color cancelColor,
  required VoidCallback onConfirm,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.secondary,
    builder: (BuildContext context) {
      final colors = context.colors;
      final textStyle = context.typography.regular24.copyWith(
        color: colors.white,
      );

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
                            child: Text(title, style: textStyle),
                          ),
                          AppIconButton.back(onTap: () => context.pop()),
                        ],
                      ),
                    ),
                    height40,
                    Text(description, textAlign: .center, style: textStyle),
                    height40,
                    AppButton(
                      color: confirmColor,
                      label: confirmText,
                      onPressed: () {
                        context.pop();
                        onConfirm.call();
                      },
                    ),
                    height20,
                    AppButton(
                      color: cancelColor,
                      label: cancelText,
                      onPressed: () {
                        context.pop();
                      },
                    ),
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
