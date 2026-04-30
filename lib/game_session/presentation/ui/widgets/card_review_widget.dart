import 'package:alias_pro/card_round/presentation/ui/widgets/multiple_words_card.dart';
import 'package:alias_pro/game_session/domain/entities/round_result.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageKeys = widget.pagedReviewedWords.keys.toList()..sort();

    return LayoutBuilder(
      builder: (_, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
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
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
        );
      },
    );
  }
}
