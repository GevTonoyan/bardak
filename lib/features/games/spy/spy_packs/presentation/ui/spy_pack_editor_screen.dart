import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/app_ui/widgets/app_input_field.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Minimum words a custom pack needs before it can be saved.
const spyPackMinWords = 3;

/// Full-screen editor to create or edit a player-created spy pack. Passed the
/// pack to edit via `state.extra` (null when creating). Dispatches save/delete
/// on the app-wide [SpyPacksBloc], which reloads the grid.
class SpyPackEditorScreen extends StatefulWidget {
  const SpyPackEditorScreen({this.initialPack, super.key});

  static const routePath = 'spyPackEditor';

  final SpyPackEntity? initialPack;

  @override
  State<SpyPackEditorScreen> createState() => _SpyPackEditorScreenState();
}

class _SpyPackEditorScreenState extends State<SpyPackEditorScreen> {
  late final TextEditingController _nameController;
  final _wordController = TextEditingController();
  late final List<String> _words;

  bool get _isEditing => widget.initialPack != null;

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      _words.length >= spyPackMinWords;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialPack?.name)
      // Keep the Save button's enabled state in sync while the name is typed.
      ..addListener(() => setState(() {}));
    _words = [...?widget.initialPack?.words];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wordController.dispose();
    super.dispose();
  }

  void _addWord() {
    final word = _wordController.text.trim();
    if (word.isEmpty || _words.contains(word)) {
      _wordController.clear();
      return;
    }
    setState(() {
      // Prepend so the freshly added word is visible at the top rather than
      // scrolled off the bottom of a long list.
      _words.insert(0, word);
      _wordController.clear();
    });
  }

  void _save() {
    context.read<SpyPacksBloc>().add(
      SaveSpyPack(
        id: widget.initialPack?.id,
        name: _nameController.text.trim(),
        words: _words,
        locale: context.locale.languageCode,
      ),
    );
    context.pop();
  }

  void _confirmDelete() {
    final l10n = context.l10n;
    final colors = context.colors;
    unawaited(
      showConfirmSheet(
        context: context,
        title: l10n.spy_delete_pack,
        description: l10n.spy_delete_pack_confirm,
        confirmText: l10n.spy_delete_pack,
        cancelText: l10n.cancel,
        confirmColor: colors.red,
        cancelColor: colors.green,
        onConfirm: () {
          context.read<SpyPacksBloc>().add(
            DeleteSpyPack(
              id: widget.initialPack!.id,
              locale: context.locale.languageCode,
            ),
          );
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;

    // The shadow band grows to fit its buttons: one when creating, two (with
    // Delete) when editing. 60 = ShadowBackground's jagged top zone, 40 = the
    // buttons' padding, plus the bottom safe inset it reserves internally.
    final actionsHeight =
        60 +
        40 +
        (_isEditing ? 140.0 : 60.0) +
        MediaQuery.of(context).padding.bottom;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: .only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              Padding(
                padding: const .fromLTRB(20, 20, 20, 0),
                child: SizedBox(
                  height: 40,
                  child: Stack(
                    children: [
                      Align(
                        alignment: .centerLeft,
                        child: AppIconButton.back(onTap: () => context.pop()),
                      ),
                      Center(
                        child: Text(
                          _isEditing
                              ? l10n.spy_edit_pack
                              : l10n.spy_create_pack,
                          style: typography.regular24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const .fromLTRB(20, 30, 20, 20),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(l10n.spy_pack_name, style: typography.regular24),
                      height20,
                      AppInputField(controller: _nameController),
                      height40,
                      Text(l10n.spy_words, style: typography.regular24),
                      height20,
                      AppInputField(
                        controller: _wordController,
                        maxLength: 20,
                        suffix: AppIcon(
                          icon: Assets.icons.add.svg(),
                          onTap: _addWord,
                        ),
                      ),
                      if (_words.isNotEmpty) ...[
                        height20,
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final word in _words)
                              AppIconTextButton(
                                onTap: () =>
                                    setState(() => _words.remove(word)),
                                padding: const .fromLTRB(16, 10, 12, 10),
                                child: Row(
                                  mainAxisSize: .min,
                                  spacing: 8,
                                  children: [
                                    Text(word, style: typography.regular18),
                                    Assets.icons.close.svg(
                                      width: 12,
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 12),
                      Text(
                        l10n.spy_min_words(spyPackMinWords),
                        style: typography.bodyMedium.copyWith(
                          color: colors.white50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: actionsHeight,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: Column(
                      children: [
                        // AppButton keeps its colour when disabled, so dim it
                        // to signal the name + minimum-words rule is unmet.
                        Opacity(
                          opacity: _canSave ? 1 : 0.5,
                          child: AppButton(
                            label: l10n.spy_save_pack,
                            color: colors.green,
                            onPressed: _canSave ? _save : null,
                          ),
                        ),
                        if (_isEditing) ...[
                          height20,
                          AppButton(
                            label: l10n.spy_delete_pack,
                            color: colors.red,
                            onPressed: _confirmDelete,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
