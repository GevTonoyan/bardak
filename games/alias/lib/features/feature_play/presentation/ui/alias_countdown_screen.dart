// feature_play/presentation/screens/alias_countdown_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AliasCountdownScreen extends StatelessWidget {
  const AliasCountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(child: Text('Alias Countdown Screen')),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Back to previous screen'),
            ),
          ],
        ),
      ),
    );
  }
}
