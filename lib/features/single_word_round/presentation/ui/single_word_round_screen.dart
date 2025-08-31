import 'package:flutter/material.dart';

class SingleWordRoundScreen extends StatefulWidget {
  const SingleWordRoundScreen({super.key});

  static const routePath = 'single_word_round';

  @override
  State<SingleWordRoundScreen> createState() => _SingleWordRoundScreenState();
}

class _SingleWordRoundScreenState extends State<SingleWordRoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Word Round')),
      body: const Center(child: Text('Single Word Round Screen')),
    );
  }
}
