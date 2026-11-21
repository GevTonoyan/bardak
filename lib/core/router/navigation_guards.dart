import 'package:bardak/core/router/invite_links.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// A check every navigation passes before it happens: [Allow] lets it
/// through, [Block] stops it (and may do something else instead).
typedef NavigationGuard = OnEnterResult Function(
  BuildContext context,
  GoRouterState current,
  GoRouterState next,
  GoRouter router,
);

/// Every guard, in the order they are asked. Add new ones here.
const List<NavigationGuard> _guards = [confirmLeavingForInvite];

/// The router's `onEnter`: asks each guard in turn, and the first to block
/// decides; when none does, the navigation goes ahead.
OnEnterResult guardNavigation(
  BuildContext context,
  GoRouterState current,
  GoRouterState next,
  GoRouter router,
) {
  for (final guard in _guards) {
    final result = guard(context, current, next, router);
    if (result is Block) return result;
  }
  return const Allow();
}
