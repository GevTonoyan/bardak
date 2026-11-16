import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Asks whether to play all of [pack]'s words or only its easy ones.
///
/// Resolves to `true` for easy words, `false` for all words, or `null` when
/// dismissed.
Future<bool?> showWordPackModeSheet({
  required BuildContext context,
  required WordPackEntity pack,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: context.colors.secondary,
    constraints: const BoxConstraints(maxWidth: double.maxFinite),
    builder: (context) {
      final l10n = context.l10n;
      final colors = context.colors;

      return PartialBottomSheet(
        titleBuilder: (_) => pack.name,
        child: Column(
          mainAxisSize: .min,
          children: [
            height40,
            _ModeButton(
              label: l10n.all_words_count(pack.words.length),
              color: colors.green,
              onPressed: () => context.pop(false),
            ),
            height20,
            _ModeButton(
              label: l10n.easy_words_count(pack.easyWords.length),
              color: colors.white20,
              onPressed: () => context.pop(true),
            ),
          ],
        ),
      );
    },
  );
}

/// One choice in the sheet.
class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      color: color,
      onPressed: onPressed,
      child: Center(
        child: SmartNumberText(label, style: context.typography.regular24),
      ),
    );
  }
}
