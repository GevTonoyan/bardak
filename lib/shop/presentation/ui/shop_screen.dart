import 'package:boardify/app_ui/theme/app_color_scheme.dart';
import 'package:boardify/app_ui/widgets/app_background.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/settings/presentation/bloc/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const routePath = 'shop';

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      overlayChild: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final scheme = AppColorScheme.values[index];

                  return InkWell(
                    onTap: () {
                      context.read<SettingsBloc>().add(
                        ChangeColorScheme(colorScheme: scheme),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scheme.displayName(context),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, _) => const SizedBox(),
                itemCount: AppColorScheme.values.length,
              ),
            ),
          ],
        ),
      ),
      child: Container(),
    );
  }
}
