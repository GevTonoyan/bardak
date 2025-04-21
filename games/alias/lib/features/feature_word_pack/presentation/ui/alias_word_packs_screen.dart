import 'package:alias/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:app_core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AliasWordPackScreen extends StatefulWidget {
  const AliasWordPackScreen({super.key});

  @override
  State<AliasWordPackScreen> createState() => _AliasWordPackScreenState();
}

class _AliasWordPackScreenState extends State<AliasWordPackScreen> {
  var selectedPackIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Mock data
    final packs = [
      AliasWordPackEntity(id: 'movies', name: 'Movies', words: []),
      AliasWordPackEntity(id: 'games', name: 'Games', words: []),
      AliasWordPackEntity(id: 'celebrities', name: 'Celebrities', words: []),
      AliasWordPackEntity(id: 'tech', name: 'Technology', words: []),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.alias_wordPack)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            children: [
              _PackCard(
                packName: 'Movies',
                emoji: '🎬',
                startColor: Color(0xFF7F00FF),
                endColor: Color(0xFFE100FF),
                isSelected: selectedPackIndex == 0,
                onTap: () {
                  setState(() {
                    selectedPackIndex = 0;
                  });
                },
              ),
              _PackCard(
                packName: 'Animals',
                emoji: '🐾',
                startColor: Color(0xFF56CCF2),
                endColor: Color(0xFF2F80ED),
                isSelected: selectedPackIndex == 1,
                onTap: () {
                  setState(() {
                    selectedPackIndex = 1;
                  });
                },
              ),
              _PackCard(
                packName: 'Food',
                emoji: '🍕',
                startColor: Color(0xFFFF512F),
                endColor: Color(0xFFDD2476),
                isSelected: selectedPackIndex == 2,
                onTap: () {
                  setState(() {
                    selectedPackIndex = 2;
                  });
                },
              ),
              _PackCard(
                packName: 'Travel',
                emoji: '🧳',
                startColor: Color(0xFF43CEA2),
                endColor: Color(0xFF185A9D),
                isSelected: selectedPackIndex == 3,
                onTap: () {
                  setState(() {
                    selectedPackIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackCard extends StatelessWidget {
  final String packName;
  final String emoji;
  final Color startColor;
  final Color endColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackCard({
    required this.packName,
    required this.emoji,
    required this.startColor,
    required this.endColor,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: endColor.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 6)),
            if (isSelected)
              BoxShadow(color: Colors.white.withOpacity(0.7), blurRadius: 10, spreadRadius: 2),
          ],
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              packName,
              style: text.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
