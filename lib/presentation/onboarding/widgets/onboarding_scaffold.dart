import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  final Widget body;
  final Widget action;

  const OnboardingScaffold({
    super.key,
    required this.body,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: body,
            ),
            action,
          ],
        ),
      ),
    );
  }
}
