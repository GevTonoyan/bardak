import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
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

  @override
  void dispose() {
    for (final controller in _teamControllers) {
      controller.dispose();
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
                  height40,
                  Text(
                    'Թիմեր՝',
                    style: typography.regular24.copyWith(color: colors.white),
                  ),
                  height20,
                  Column(
                    children: _teamControllers.map((controller) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppInputField(
                                controller: controller,
                                suffix:
                                    _teamControllers.length >
                                        AppConstants.minTeamCount
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            controller.dispose();
                                            _teamControllers.remove(controller);
                                          });
                                        },
                                        child: Assets.minus.svg(),
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (_teamControllers.length < AppConstants.maxTeamCount)
                    AppButton(
                      label: 'Ավելացնել',
                      color: colors.white20,
                      icon: Assets.plus.svg(),
                      onPressed: () {
                        setState(() {
                          _teamControllers.add(TextEditingController());
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
}
