import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/bootstrap/startup_guard.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows [child] until [StartupGuard] reports a failure, then replaces the
/// whole app with [StartupErrorApp].
class StartupGate extends StatelessWidget {
  const StartupGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StartupFailure?>(
      valueListenable: StartupGuard.failure,
      builder: (context, failure, child) =>
          failure == null ? child! : StartupErrorApp(failure: failure),
      child: child,
    );
  }
}

/// Standalone app for a failed startup. It depends on nothing that startup
/// initialises (DI, settings, localizations), so it renders even when those
/// are what broke. Copy is English-only for the same reason.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({required this.failure, super.key});

  final StartupFailure failure;

  @override
  Widget build(BuildContext context) {
    final typography = AppTextStyles();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(typography),
      home: AppThemeProvider(
        data: AppThemeData(
          colors: AppColorScheme.main.colors,
          typography: typography,
          themeData: buildAppTheme(typography),
        ),
        child: _StartupErrorScreen(failure: failure),
      ),
    );
  }
}

class _StartupErrorScreen extends StatelessWidget {
  const _StartupErrorScreen({required this.failure});

  final StartupFailure failure;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                "Bardak couldn't start",
                style: context.typography.regular28,
              ),
              height20,
              Text(
                'Please copy this report and send it to the developer.',
                style: context.typography.bodyMedium.copyWith(
                  color: context.colors.white,
                ),
              ),
              height20,
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      failure.report,
                      style: context.typography.bodySmall.copyWith(
                        color: context.colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              height20,
              AppButton(
                label: 'Copy report',
                color: context.colors.green,
                onPressed: () => Clipboard.setData(
                  ClipboardData(text: failure.report),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
