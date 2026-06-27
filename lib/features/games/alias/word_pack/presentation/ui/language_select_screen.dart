import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/features/settings/presentation/ui/app_languages_list.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LanguageSelectScreen extends Page<void> {
  const LanguageSelectScreen({super.key});

  static const routePath = 'language_select';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: PartialBottomSheet(
        titleBuilder: (context) => context.l10n.languages,
        child: const _LanguageSelectBody(),
      ),
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
