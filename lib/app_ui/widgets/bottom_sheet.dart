import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Route<T> buildAppBottomSheetRoute<T>({
  required BuildContext context,
  required Page<T> settings,
  required String title,
  required Widget child,
}) {
  return ModalBottomSheetRoute<T>(
    settings: settings,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final colors = context.appTheme.colors;
      final typography = context.appTheme.typography;

      return Material(
        color: colors.secondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SafeArea(
          child: Padding(
            padding: const .all(20),
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
                          style: typography.regular24.copyWith(
                            color: colors.white,
                          ),
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
    },
  );
}
