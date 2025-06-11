import 'package:app_core/extensions/context_extension.dart';
import 'package:app_core/ui_kit/widgets/game_popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AliasCardModeGameplayScreen extends StatefulWidget {
  const AliasCardModeGameplayScreen({super.key});

  @override
  State<AliasCardModeGameplayScreen> createState() =>
      _AliasCardModeGameplayScreenState();
}

class _AliasCardModeGameplayScreenState
    extends State<AliasCardModeGameplayScreen> {
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
  int remainingSeconds = 20; // Will be dynamic later
  late final Ticker _ticker;
  var isTickerPaused = false;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
    // Disable back swipe
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _onTick(Duration elapsed) {
    final seconds = 20 - elapsed.inSeconds;
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text(
                      '$remainingSeconds',
                      style: text.displayMedium.copyWith(
                        color:
                            remainingSeconds <= 5
                                ? colors.error
                                : remainingSeconds <= 15
                                ? colors.warning
                                : colors.primary,
                      ),
                    ),
                    const Spacer(),
                    // Pause Button
                    IconButton(
                      icon:
                          isTickerPaused
                              ? const Icon(Icons.play_arrow)
                              : const Icon(Icons.pause),
                      onPressed: () {
                        setState(() {
                          _ticker.isActive ? _ticker.stop() : _ticker.start();
                          isTickerPaused = !isTickerPaused;
                        });
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        showGamePopupDialog(
                          context: context,
                          title:
                              context
                                  .localizations
                                  .alias_roundOverview_confirmExit_title,
                          message:
                              context
                                  .localizations
                                  .alias_roundOverview_confirmExit_message,
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
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: words.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndexes.contains(index);
                      return Material(
                        color:
                            isSelected
                                ? colors.success.withValues(alpha: 0.2)
                                : colors.surface,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected ? colors.success : colors.outline,
                            width: 1.5,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _toggleSelection(index),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
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
                                if (isSelected)
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    child:
                                        isSelected
                                            ? Icon(
                                              Icons.check_circle,
                                              key: const ValueKey(true),
                                              color: colors.success,
                                            )
                                            : const SizedBox.shrink(
                                              key: ValueKey(false),
                                            ),
                                  ),
                              ],
                            ),
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
