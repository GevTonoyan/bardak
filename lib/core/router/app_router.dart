import 'package:alias/core/alias_route.dart';
import 'package:boardify/features/feature_app_startup/presentation/ui/app_startup_screen.dart';
import 'package:boardify/features/feature_games/presentation/ui/games_screen.dart';
import 'package:boardify/features/feature_settings/presentation/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  initialLocation: RouteNames.appStartup,
  navigatorKey: rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: RouteNames.appStartup,
      name: RouteNames.appStartup,
      redirect: (context, state) => RouteNames.appStartup,
      builder: (context, state) {
        return const AppStartupScreen();
      },
    ),
    GoRoute(
      path: RouteNames.games,
      name: RouteNames.games,
      builder: (context, state) {
        return const GamesScreen();
      },
      routes: [
        aliasRouter,
        GoRoute(
          path: RouteNames.settings,
          name: RouteNames.settings,
          builder: (context, state) {
            return const SettingsScreen();
          },
        ),
      ],
    ),
  ],
);

class RouteNames {
  static const initial = '/';
  static const appStartup = '/app_startup';
  static const games = '/games';
  static const settings = 'settings';
}
