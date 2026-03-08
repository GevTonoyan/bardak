import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon.dart';
import 'package:alias_pro/app_ui/widgets/app_input_field.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:alias_pro/utils/constants/constants.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:alias_pro/word_pack/presentation/ui/word_packs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _predefinedTeamNames = [
  'Արծիվներ',
  'Վագրեր',
  'Առյusage',
  'Կայծակներ',
  'Փdelays',
  'Հրdelays',
];

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
  late final _teamControllers = <TextEditingController>[
    TextEditingController(text: '${context.l10n.preGameTeam} 1'),
    TextEditingController(text: '${context.l10n.preGameTeam} 2'),
  ];

  late final _teamFocusNodes = <FocusNode>[FocusNode(), FocusNode()];

  @override
  void initState() {
    super.initState();
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
                    'Թիմեր՝',
                    style: typography.regular24.copyWith(color: colors.white),
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

    for (final name in _predefinedTeamNames) {
      if (!currentNames.contains(name)) return name;
    }

    return '${context.l10n.preGameTeam} ${_teamControllers.length + 1}';
  }
}
