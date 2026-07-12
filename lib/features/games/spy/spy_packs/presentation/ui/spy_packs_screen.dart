import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/language_icon.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_language_select_screen.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_pack_item.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/ui/spy_role_reveal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SpyPacksScreen extends StatefulWidget {
  const SpyPacksScreen({super.key});

  static const routePath = 'spyPacks';

  @override
  State<SpyPacksScreen> createState() => _SpyPacksScreenState();
}

class _SpyPacksScreenState extends State<SpyPacksScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<SpyPacksBloc>().add(
      LoadSpyPacks(context.locale.languageCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpyPacksBloc, SpyPacksState>(
      listenWhen: (_, current) => current is SpyGameReady,
      listener: (context, state) {
        if (state is SpyGameReady) {
          context.goNamed(SpyRoleRevealScreen.routePath, extra: state.session);
        }
      },
      child: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const .only(left: 20, top: 20, right: 20),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    AppIconButton.back(onTap: () => context.pop()),
                    LanguageIcon(
                      locale: AppLocale.fromString(
                        context.locale.languageCode,
                      ),
                      size: 40,
                      onTap: () {
                        unawaited(
                          context.pushNamed(
                            SpyLanguageSelectScreen.routePath,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<SpyPacksBloc, SpyPacksState>(
                builder: (context, state) {
                  return switch (state) {
                    SpyPacksInitial() => const SizedBox.shrink(),
                    SpyPacksLoaded(:final packs) => Expanded(
                      child: _Packs(packs: packs),
                    ),
                    SpyGameReady(:final packs) => Expanded(
                      child: _Packs(packs: packs),
                    ),
                    SpyPacksNotCached(:final fallbackPacks) => Expanded(
                      child: _Packs(packs: fallbackPacks, shouldDownload: true),
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Packs extends StatelessWidget {
  const _Packs({required this.packs, this.shouldDownload = false});

  final List<SpyPackEntity> packs;
  final bool shouldDownload;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        height30,
        Expanded(
          child: GridView.builder(
            padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
            // mainAxisExtent matches ButtonSize.extraLarge, so the tiles
            // keep the AppButton press effect at any screen width.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 157,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final pack = packs[index];

              return SpyPackItem(
                name: pack.name,
                imageUrl: pack.image,
                imageBlurHash: pack.imageBlurHash,
                shouldDownload: shouldDownload,
                onTap: () {
                  final locale = context.locale.languageCode;
                  final bloc = context.read<SpyPacksBloc>();
                  if (shouldDownload) {
                    bloc.add(DownloadSpyPacks(locale));
                  } else {
                    bloc.add(StartSpyGame(pack: pack, locale: locale));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
