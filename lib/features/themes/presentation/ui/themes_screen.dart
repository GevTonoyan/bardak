import 'dart:async';

import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/coin_balance_widget.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_state.dart';
import 'package:bardak/features/themes/domain/theme_cost.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_bloc.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_event.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  static const routePath = 'themes';

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

class _ThemesScreenState extends State<ThemesScreen> {
  static const _itemHeight = 157.0;
  static const _separatorHeight = 12.0;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTheme();
    });
  }

  void _scrollToSelectedTheme() {
    final selectedScheme = context
        .read<SettingsBloc>()
        .state
        .appSettings
        .colorScheme;
    final index = AppColorScheme.values.indexOf(selectedScheme);
    if (index <= 0 || !_scrollController.hasClients) return;

    final position = _scrollController.position;
    final itemTop = index * (_itemHeight + _separatorHeight);
    final itemBottom = itemTop + _itemHeight;

    final viewportTop = position.pixels;
    final viewportBottom = position.pixels + position.viewportDimension;

    // Already fully visible — do nothing.
    if (itemTop >= viewportTop && itemBottom <= viewportBottom) return;

    // Last item — scroll to the very bottom.
    if (index == AppColorScheme.values.length - 1) {
      unawaited(
        _scrollController.animateTo(
          position.maxScrollExtent + 100,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        ),
      );
      return;
    }

    // Otherwise scroll so the item is near the top with some padding.
    final target = (itemTop - 20).clamp(0.0, position.maxScrollExtent);
    unawaited(
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return BlocListener<ThemesBloc, ThemesState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onPurchaseStatusChanged,
      child: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            spacing: 30,
            children: [
              Padding(
                padding: const .only(left: 20, top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppIconButton.back(onTap: () => context.pop()),
                    const CoinBalanceWidget(),
                  ],
                ),
              ),
              BlocBuilder<ThemesBloc, ThemesState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
                      itemBuilder: (context, index) {
                        final scheme = AppColorScheme.values[index];
                        return AppButton(
                          label: scheme.displayName(context),
                          color: scheme.colors.secondary,
                          size: .extraLarge,
                          onPressed: () => _onThemeTapped(scheme, state),
                          child: Container(
                            padding: const .symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: Assets.images.themeBackground.provider(),
                                opacity: 0.2,
                              ),
                            ),
                            child: Column(
                              children: [
                                _AppThemeOwnedInfo(scheme),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: .end,
                                    spacing: 8,
                                    children: [
                                      if (!state.isOwned(scheme))
                                        Assets.icons.lock.svg(),
                                      Text(
                                        scheme.displayName(context),
                                        style: typography.regular24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: _separatorHeight),
                      itemCount: AppColorScheme.values.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onThemeTapped(AppColorScheme scheme, ThemesState state) {
    state.isOwned(scheme)
        ? _selectTheme(scheme)
        : unawaited(_confirmPurchase(scheme));
  }

  void _selectTheme(AppColorScheme scheme) {
    context.read<SettingsBloc>().add(ChangeColorScheme(colorScheme: scheme));
  }

  Future<void> _confirmPurchase(AppColorScheme scheme) {
    final l10n = context.l10n;
    final colors = context.colors;
    return showConfirmSheet(
      context: context,
      title: l10n.unlock_theme_title,
      description: l10n.unlock_theme_description,
      confirmText: l10n.unlock_theme_confirm,
      cancelText: l10n.cancel,
      confirmColor: colors.green,
      cancelColor: colors.white20,
      onConfirm: () =>
          context.read<ThemesBloc>().add(PurchaseTheme(theme: scheme)),
    );
  }

  void _onPurchaseStatusChanged(BuildContext context, ThemesState state) {
    switch (state.status) {
      case .purchaseSuccess:
        final theme = state.lastPurchased;
        if (theme != null) _selectTheme(theme);
      case .insufficientFunds:
        unawaited(
          showAppNotification(
            context,
            message: context.l10n.not_enough_coins,
            icon: Assets.icons.coin.svg(width: 18, height: 18),
          ),
        );
      case .idle:
      case .purchasing:
        break;
    }
  }
}

class _AppThemeOwnedInfo extends StatelessWidget {
  const _AppThemeOwnedInfo(this.scheme);

  final AppColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ThemesBloc, ThemesState, bool>(
      selector: (state) => state.isOwned(scheme),
      builder: (context, isThemeOwned) {
        if (!isThemeOwned) {
          return Row(
            mainAxisAlignment: .end,
            spacing: 8,
            children: [
              Text(
                '$themeCost',
                style: context.typography.regular24.withNumericFont,
              ),
              Assets.icons.coin.svg(width: 18, height: 18),
            ],
          );
        }

        return BlocSelector<SettingsBloc, SettingsState, bool>(
          selector: (state) => state.appSettings.colorScheme == scheme,
          builder: (context, isThemeSelected) {
            return Align(
              alignment: .topRight,
              child: AppIconButton.themeOwned(
                context: context,
                isActive: isThemeSelected,
              ),
            );
          },
        );
      },
    );
  }
}
