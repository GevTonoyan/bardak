import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_text_button.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/rewards/presentation/ui/reward_item.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  static const routePath = 'rewards';

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return ScreenBackground(
      shadowHeight: 850,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                  AppIconTextButton(number: 123, onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 150),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: colors.white,
                boxShadow: [
                  BoxShadow(color: colors.shadow, offset: const Offset(0, 12)),
                ],
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                padding: EdgeInsets.zero,
                children: List.generate(9, (index) {
                  return const RewardItem();
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
