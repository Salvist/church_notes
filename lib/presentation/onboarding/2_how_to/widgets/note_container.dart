import 'package:flutter/material.dart';

class NoteContainer extends StatelessWidget {
  final Widget child;
  const NoteContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.onSurface),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}
