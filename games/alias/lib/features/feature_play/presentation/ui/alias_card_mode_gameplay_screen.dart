import 'package:app_core/extensions/context_extension.dart';
import 'package:app_core/ui_kit/widgets/game_popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AliasCardModeGameplayScreen extends StatefulWidget {
  const AliasCardModeGameplayScreen({super.key});

  @override
  State<AliasCardModeGameplayScreen> createState() => _AliasCardModeGameplayScreenState();
}

class _AliasCardModeGameplayScreenState extends State<AliasCardModeGameplayScreen> {
  final List<String> words = [
    'Mountain',
    'Laptop',
    'Book',
    'Guitar',
    'River',
    'Spaceship',
    'Chocolate',
    'Umbrella',
  ];

  final Set<int> selectedIndexes = {};
  int remainingSeconds = 60; // Will be dynamic later
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
    // Disable back swipe
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _onTick(Duration elapsed) {
    final seconds = 60 - elapsed.inSeconds;
    if (seconds <= 0) {
      _ticker.stop();
      setState(() => remainingSeconds = 0);
      // End round logic here
    } else {
      setState(() => remainingSeconds = seconds);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndexes.contains(index)) {
        selectedIndexes.remove(index);
      } else {
        selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with timer & close
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      '$remainingSeconds',
                      style: text.headlineLarge.copyWith(color: colors.primary),
                    ),
                    const Spacer(),
                    // Pause Button
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () {
                        _ticker.stop();
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        showGamePopupDialog(
                          context: context,
                          title: context.localizations.alias_roundOverview_confirmExit_title,
                          message: context.localizations.alias_roundOverview_confirmExit_message,
                          confirmText: context.localizations.general_yes,
                          cancelText: context.localizations.general_no,
                          onConfirm: () => context.pop(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Word cards
              Expanded(
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexes.contains(index);
                      return GestureDetector(
                        onTap: () => _toggleSelection(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 700),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? colors.success.withValues(alpha: 0.2) : colors.surface,
                            border: Border.all(
                              color: isSelected ? colors.success : colors.outline,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  words[index],
                                  style: text.titleMedium.copyWith(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (isSelected) Icon(Icons.check_circle, color: colors.success),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
