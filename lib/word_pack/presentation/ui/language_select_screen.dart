import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/settings/presentation/ui/app_languages_list.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectScreen extends Page<void> {
  const LanguageSelectScreen({super.key});

  static const routePath = 'language_select';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: const _LanguageSelectBody(),
      titleBuilder: (context) => context.l10n.settings,
    );
  }
}

class _LanguageSelectBody extends StatelessWidget {
  const _LanguageSelectBody();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      height30,
      AppLanguagesList(afterSelection: () => context.pop()),
    ],
  );
}
