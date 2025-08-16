import 'package:boardify/core/ui_kit/widgets/app_loader.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/feature_app_startup/presentation/bloc/app_startup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppStartupScreen extends StatelessWidget {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartupBloc, AppStartupState>(
      listener: (BuildContext context, AppStartupState state) {
        if (state is AppStartupLoaded) {
          context.goNamed(RouteNames.games);
        }
      },
      child: const Scaffold(body: AppLoader()),
    );
  }
}
