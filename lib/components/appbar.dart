import 'package:flutter/material.dart';
import 'package:rhyme_app/components/glass.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget? left;
  final Widget? right;

  const AppHeader({super.key, required this.title, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Glass(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            left ?? const SizedBox(width: 36),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
            if (right != null) right!,
          ],
        ),
      ),
    );
  }
}