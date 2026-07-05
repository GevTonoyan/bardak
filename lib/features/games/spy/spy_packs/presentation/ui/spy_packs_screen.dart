import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
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
      listenWhen: (previous, current) => current is SpyGameReady,
      listener: (context, state) {
        if (state is! SpyGameReady) return;
        context.goNamed(SpyRoleRevealScreen.routePath, extra: state.session);
      },
      child: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const .only(left: 20, top: 20, right: 20),
                child: Row(
                  children: [
                    AppIconButton.back(onTap: () => context.pop()),
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
                    SpyPacksFailure() => const Expanded(child: _Failure()),
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
  const _Packs({required this.packs});

  final List<SpyPackEntity> packs;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        height30,
        Expanded(
          child: ListView.separated(
            padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
            itemBuilder: (context, index) {
              final pack = packs[index];

              return SpyPackItem(
                name: pack.name,
                wordsCount: pack.words.length,
                imageUrl: pack.image,
                imageBlurHash: pack.imageBlurHash,
                onTap: () => context.read<SpyPacksBloc>().add(
                  StartSpyGame(
                    pack: pack,
                    locale: context.locale.languageCode,
                  ),
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemCount: packs.length,
          ),
        ),
      ],
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              l10n.downloadWordsNetworkError,
              textAlign: .center,
              style: context.typography.regular20,
            ),
            height30,
            AppButton(
              label: l10n.retry,
              color: context.colors.green,
              onPressed: () => context.read<SpyPacksBloc>().add(
                LoadSpyPacks(context.locale.languageCode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
