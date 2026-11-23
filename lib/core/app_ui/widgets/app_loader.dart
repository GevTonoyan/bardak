import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// A white spinner for while something loads, with an optional [label]
/// below it.
class AppLoader extends StatelessWidget {
  const AppLoader({this.label, super.key});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Column(
      mainAxisSize: .min,
      children: [
        CircularProgressIndicator(
          color: context.colors.white,
          strokeCap: .round,
        ),
        if (label != null) ...[
          const SizedBox(height: 20),
          Text(
            label,
            textAlign: .center,
            style: context.typography.regular20,
          ),
        ],
      ],
    );
  }
}
