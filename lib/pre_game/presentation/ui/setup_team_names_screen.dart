import 'dart:async';
import 'dart:math';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon.dart';
import 'package:alias_pro/app_ui/widgets/app_input_field.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:alias_pro/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:alias_pro/utils/constants/constants.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:alias_pro/word_pack/presentation/ui/word_packs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SetupTeamNamesScreen extends Page<void> {
  const SetupTeamNamesScreen({super.key});

  static const routePath = 'setupTeamNames';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: const _SetupTeamNamesBody(),
      title: 'Մասնակիցներ',
    );
  }
}

class _SetupTeamNamesBody extends StatefulWidget {
  const _SetupTeamNamesBody();

  @override
  State<_SetupTeamNamesBody> createState() => _SetupTeamNamesBodyState();
}

class _SetupTeamNamesBodyState extends State<_SetupTeamNamesBody> {
  late final List<TextEditingController> _teamControllers;
  late final List<FocusNode> _teamFocusNodes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appLocale = AppLocales.fromString(context.locale.languageCode);
    final predefined =
        context.read<PreGameBloc>().state.predefinedTeamNames[appLocale] ?? {};
    final firstName = _pickDefaultName({}, predefined: predefined);
    final secondName = _pickDefaultName({firstName}, predefined: predefined);
    _teamControllers = [
      TextEditingController(text: firstName),
      TextEditingController(text: secondName),
    ];
    _teamFocusNodes = [FocusNode(), FocusNode()];
    _teamFocusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (final controller in _teamControllers) {
      controller.dispose();
    }
    for (final focusNode in _teamFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PreGameBloc>();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  height30,
                  Text(
                    'Թիમեर՝',
                    style: typography.regular24,
                  ),
                  height20,
                  Column(
                    children: [
                      for (int i = 0; i < _teamControllers.length; i++)
                        Padding(
                          padding: const .only(bottom: 20),
                          child: AppInputField(
                            controller: _teamControllers[i],
                            focusNode: _teamFocusNodes[i],
                            suffix:
                                _teamControllers.length >
                                    AppConstants.minTeamCount
                                ? AppIcon(
                                    icon: Container(
                                      height: 4,
                                      width: 20,
                                      color: colors.white,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _teamControllers[i].dispose();
                                        _teamControllers.remove(
                                          _teamControllers[i],
                                        );

                                        _teamFocusNodes[i].dispose();
                                        _teamFocusNodes.remove(
                                          _teamFocusNodes[i],
                                        );
                                      });
                                    },
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                  if (_teamControllers.length < AppConstants.maxTeamCount)
                    AppButton(
                      label: 'Ավելացնել',
                      color: colors.white20,
                      icon: Assets.icons.add.svg(),
                      onPressed: () {
                        setState(() {
                          _teamControllers.add(
                            TextEditingController(
                              text: _getNextDefaultName(),
                            ),
                          );
                          _teamFocusNodes.add(FocusNode());
                          _teamFocusNodes.last.requestFocus();
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          height20,
          AppButton(
            label: 'Շարունակել',
            color: colors.green,
            onPressed: () {
              final teamNames = _teamControllers
                  .map((controller) => controller.text)
                  .toList();
              bloc.add(AddTeamsEvent(teamNames));

              unawaited(context.pushNamed(WordPackScreen.routePath));
            },
          ),
        ],
      ),
    );
  }

  String _getNextDefaultName() {
    final currentNames = _teamControllers.map((e) => e.text.trim()).toSet();
    final appLocale = AppLocales.fromString(context.locale.languageCode);
    final predefined =
        context.read<PreGameBloc>().state.predefinedTeamNames[appLocale] ?? {};
    return _pickDefaultName(currentNames, predefined: predefined);
  }

  /// Picks a random unused name from [predefined] that is not in [taken].
  /// Falls back to "Team N" (where N = taken.length + 1) when exhausted.
  static String _pickDefaultName(
    Set<String> taken, {
    Set<String> predefined = const {},
  }) {
    final available = predefined
        .where((name) => !taken.contains(name))
        .toList();

    if (available.isNotEmpty) {
      return available[Random().nextInt(available.length)];
    }

    return 'Team ${taken.length + 1}';
  }
}
