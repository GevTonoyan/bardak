import 'package:app_core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:app_core/ui_kit/theme/app_theme_provider.dart';
import 'package:app_core/ui_kit/theme/colors/app_colors.dart';
import 'package:app_core/ui_kit/theme/text_styles/app_text_styles.dart';

class AliasCardModeGameplayScreen extends StatefulWidget {
  const AliasCardModeGameplayScreen({super.key});

  @override
  State<AliasCardModeGameplayScreen> createState() => _AliasCardModeGameplayScreenState();
}

class _AliasCardModeGameplayScreenState extends State<AliasCardModeGameplayScreen> {
  int _currentWordIndex = 0;
  int _score = 0;
  int _timeLeft = 60; // 60 seconds per round
  bool _isPlaying = false;
  final List<String> _words = [
    'Apple', 'Banana', 'Computer', 'Dolphin', 'Elephant',
    'Football', 'Guitar', 'House', 'Internet', 'Jacket',
    // Add more words as needed
  ];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _timeLeft = 60;
      _score = 0;
      _currentWordIndex = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_timeLeft > 0 && _isPlaying) {
        setState(() {
          _timeLeft--;
        });
        _startTimer();
      } else {
        setState(() {
          _isPlaying = false;
        });
        _showGameOverDialog();
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Game Over!',
          // style: typography.headline2.copyWith(
          //   color: colors.primary,
          // ),
        ),
        content: Text(
          'Your score: $_score',
          //style: typography.body1,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startGame();
            },
            child: Text(
              'Play Again',
              // style: typography.button.copyWith(
              //   color: colors.primary,
              // ),
            ),
          ),
        ],
      ),
    );
  }

  void _onCorrect() {
    setState(() {
      _score++;
      _currentWordIndex = (_currentWordIndex + 1) % _words.length;
    });
  }

  void _onSkip() {
    setState(() {
      _currentWordIndex = (_currentWordIndex + 1) % _words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;
    
    return Scaffold(
       body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Timer and Score
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Score: $_score',
                    // style: typography.headline3.copyWith(
                    //   color: colors.primary,
                    // ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$_timeLeft s',
                      // style: typography.headline3.copyWith(
                      //   color: colors.primary,
                      // ),
                    ),
                  ),
                ],
              ),
            ),

            // Word Card
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _words[_currentWordIndex],
                        // style: typography.headline1.copyWith(
                        //   color: colors.textPrimary,
                        // ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ActionButton(
                            icon: Icons.close,
                            color: colors.error,
                            onPressed: _onSkip,
                          ),
                          _ActionButton(
                            icon: Icons.check,
                            color: colors.success,
                            onPressed: _onCorrect,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
      ),
    );
  }
} 