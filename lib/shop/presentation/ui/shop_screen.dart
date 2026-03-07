import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/app_ui/theme/colors/app_black_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_blue_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_green_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_light_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_pink_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_purple_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_red_colors.dart';
import 'package:alias_pro/app_ui/theme/colors/app_yellow_colors.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/coin_balance_widget.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const routePath = 'shop';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final bottomInset = MediaQuery.of(context).padding.bottom;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                  const CoinBalanceWidget(),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
                itemBuilder: (context, index) {
                  final scheme = AppColorScheme.values[index];
                  return AppButton(
                    label: scheme.displayName(context),
                    color: _buttonBackgroundColor(colors, scheme),
                    size: .extraLarge,
                    onPressed: () {
                      context.read<SettingsBloc>().add(
                        ChangeColorScheme(colorScheme: scheme),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: .start,
                              mainAxisAlignment: .end,
                              spacing: 8,
                              children: [
                                Text(
                                  '500',
                                  style: typography.regular24.copyWith(
                                    color: colors.white,
                                    fontFamily: 'Digitalt',
                                  ),
                                ),
                                Assets.icons.coin.svg(width: 18, height: 18),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: .end,
                              spacing: 8,
                              children: [
                                Assets.icons.lock.svg(),
                                Text(
                                  scheme.displayName(context),
                                  style: typography.regular24.copyWith(
                                    color: colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemCount: AppColorScheme.values.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _buttonBackgroundColor(AppColors colors, AppColorScheme colorScheme) {
    return switch (colorScheme) {
      .main => AppMainColors().secondary,
      .purple => AppPurpleColors().secondary,
      .yellow => AppYellowColors().secondary,
      .blue => AppBlueColors().secondary,
      .green => AppGreenColors().secondary,
      .pink => AppPinkColors().secondary,
      .red => AppRedColors().secondary,
      .black => AppBlackColors().secondary,
    };
  }
}
