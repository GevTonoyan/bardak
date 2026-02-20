import 'package:boardify/card_round/presentation/ui/widgets/multiple_words_card.dart';
import 'package:boardify/game_session/domain/entities/round_result.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CardReviewWidget extends StatefulWidget {
  const CardReviewWidget({
    required this.pagedReviewedWords,
    required this.guessedByPage,
    required this.onGuessedChanged,
    super.key,
  });

  final Map<int, List<ReviewedWord>> pagedReviewedWords;
  final Map<int, Set<String>> guessedByPage;
  final ValueChanged<Set<String>> onGuessedChanged;

  @override
  State<CardReviewWidget> createState() => _CardReviewWidgetState();
}

class _CardReviewWidgetState extends State<CardReviewWidget> {
  late final PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    if (!_pageController.hasClients) return;
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPageIndex && mounted) {
      setState(() => _currentPageIndex = page);
    }
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final pageCount = widget.pagedReviewedWords.length;
    final pageKeys = widget.pagedReviewedWords.keys.toList()..sort();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            clipBehavior: Clip.none,
            controller: _pageController,
            itemCount: pageKeys.length,
            itemBuilder: (context, index) {
              final pageIndex = pageKeys[index];
              final entry = widget.pagedReviewedWords[pageIndex]!;
              final words = entry.map((e) => e.word).toList(growable: false);
              final guessed = widget.guessedByPage[pageIndex] ?? <String>{};

              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MultipleWordsCard(
                    words: words,
                    guessed: guessed,
                    onTap: ({required selected, required word}) {
                      final allGuessed = widget.guessedByPage.values
                          .expand((e) => e)
                          .toSet();
                      final newSet = selected
                          ? {...allGuessed, word}
                          : allGuessed.difference({word});
                      widget.onGuessedChanged(newSet);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        if (pageCount > 1) ...[
          const SizedBox(height: 44),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageCount,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPageIndex
                      ? colors.white
                      : colors.white20,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      color: colors.black.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
