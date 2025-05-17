import 'package:alias/core/alias_route.dart';
import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_main/feature_main_scope.dart';
import 'package:alias/features/feature_settings/alias_settings_scope.dart';
import 'package:alias/features/feature_word_pack/alias_word_packs_scope.dart';
import 'package:app_core/extensions/context_extension.dart';
import 'package:app_core/ui_kit/theme/app_theme_provider.dart';
import 'package:app_core/ui_kit/widgets/game_card.dart';
import 'package:boardify/core/constants.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppThemeProvider.of(context).colors;
    final textStyles = AppThemeProvider.of(context).typography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Boardify', style: textStyles.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.goNamed(RouteNames.settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.games_availableGames,
              style: textStyles.titleLarge.copyWith(color: colors.onBackground),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  GameCard(
                    title: context.localizations.alias_title,
                    description: context.localizations.games_aliasDescription,
                    heroTag: AliasConstants.heroTag,
                    imageAssetPath: AppConstants.aliasImagePath,
                    onTap: () async {
                      // TODO come up with precise way to inject all alias settings
                      await injectAliasSettingsScope();
                      await injectWordPacksScope();
                      injectAliasMainScope();
                      if (context.mounted) {
                        context.goNamed(AliasRouteNames.mainMenu);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
