import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/ui/sea_battle_join_room_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/ui/sea_battle_settings_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:bardak/features/splash/presentation/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

// How invite links (https://bardakgames.com/join/<code>) find their way
// in: the route they match, where it leads, and a check before they take
// the player away from something.

const _codeParameter = 'code';

/// The route invite links match.
const inviteRoutePath = '${SeaBattleRoomEntity.invitePath}/:$_codeParameter';

/// Sends an invite to the join screen inside Sea Battle, so Back leads to
/// its settings and then home.
String redirectInvite(BuildContext context, GoRouterState state) =>
    _joinRoomLocation(state, state.pathParameters[_codeParameter]!);

/// The join screen for room [code]. Codes are written in capitals, so a
/// link typed in lowercase still works.
String _joinRoomLocation(GoRouterState state, String code) =>
    state.namedLocation(
      SeaBattleJoinRoomScreen.routeName,
      pathParameters: {
        SeaBattleJoinRoomScreen.codeParameter: code.toUpperCase(),
      },
    );

/// Screens an invite may replace without asking, as nothing is lost.
const Set<String> _screensSafeToLeave = {
  SplashScreen.routePath,
  HomeScreen.routePath,
  '${HomeScreen.routePath}/${SeaBattleSettingsScreen.routePath}',
};

/// A navigation guard: an invite link opened in the middle of something,
/// such as a game, asks before leaving it; everything else goes through.
OnEnterResult confirmLeavingForInvite(
  BuildContext context,
  GoRouterState current,
  GoRouterState next,
  GoRouter router,
) {
  final isInvite = next.uri.path.startsWith(
    '${SeaBattleRoomEntity.invitePath}/',
  );
  final path = current.uri.path;
  if (!isInvite || path.isEmpty || _screensSafeToLeave.contains(path)) {
    return const Allow();
  }

  final code =
      next.pathParameters[_codeParameter] ?? next.uri.pathSegments.last;
  return Block.then(() async {
    final sheetContext = router.routerDelegate.navigatorKey.currentContext;
    if (sheetContext == null) return;
    final colors = sheetContext.colors;
    final l10n = sheetContext.l10n;
    await showConfirmSheet(
      context: sheetContext,
      title: l10n.sea_battle_join_invite_title,
      description: l10n.sea_battle_join_invite_description,
      confirmText: l10n.sea_battle_join,
      cancelText: l10n.cancel,
      confirmColor: colors.green,
      cancelColor: colors.red,
      // Straight to the join screen, which this check lets through.
      onConfirm: () => router.goNamed(
        SeaBattleJoinRoomScreen.routeName,
        pathParameters: {
          SeaBattleJoinRoomScreen.codeParameter: code.toUpperCase(),
        },
      ),
    );
  });
}
