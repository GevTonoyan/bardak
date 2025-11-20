import 'package:boardify/app_ui/theme/app_theme_provider.dart';
import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeProvider.of(context).colors;
    final textStyles = AppThemeProvider.of(context).typography;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: colors.primary, strokeWidth: 4),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text!,
              style: textStyles.bodyMedium.copyWith(color: colors.onBackground),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
