import 'dart:async';
import 'dart:math' as math;

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
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_pack_editor_screen.dart';
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
                    SpyPacksNotCached(
                      :final fallbackPacks,
                      :final customPacks,
                    ) =>
                      Expanded(
                        child: _Packs(
                          packs: [...customPacks, ...fallbackPacks],
                          shouldDownload: true,
                        ),
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

  void _openEditor(BuildContext context, {SpyPackEntity? pack}) {
    unawaited(
      context.pushNamed(SpyPackEditorScreen.routePath, extra: pack),
    );
  }

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
            // The leading cell always creates a new pack.
            itemCount: packs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _CreatePackTile(onTap: () => _openEditor(context));
              }

              final pack = packs[index - 1];
              // Custom packs always play; only built-in placeholders download.
              final downloads = shouldDownload && !pack.isCustom;

              return SpyPackItem(
                name: pack.name,
                imageUrl: pack.image,
                imageBlurHash: pack.imageBlurHash,
                shouldDownload: downloads,
                isCustom: pack.isCustom,
                onEdit: pack.isCustom
                    ? () => _openEditor(context, pack: pack)
                    : null,
                onTap: () {
                  final locale = context.locale.languageCode;
                  final bloc = context.read<SpyPacksBloc>();
                  if (downloads) {
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

/// The "Create pack" tile that leads the grid — a dashed "add" slot, kept
/// visually distinct from the filled pack cards beside it.
class _CreatePackTile extends StatelessWidget {
  const _CreatePackTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      behavior: .opaque,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(color: colors.white50),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.white10,
            borderRadius: .circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: .min,
              spacing: 12,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: colors.white20,
                    border: Border.all(color: colors.white, width: 2),
                  ),
                  child: Icon(Icons.add_rounded, color: colors.white, size: 30),
                ),
                Text(
                  context.l10n.spy_new_pack,
                  style: context.typography.regular20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle border for the "add" tile.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const radius = 12.0;
    const strokeWidth = 2.0;
    const dashLength = 8.0;
    const gapLength = 6.0;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(strokeWidth / 2),
          const Radius.circular(radius),
        ),
      );

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}
