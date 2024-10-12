import 'package:church_notes/presentation/home/widgets/privacy_policy_button.dart';
import 'package:church_notes/presentation/home/widgets/terms_and_conditions_button.dart';
import 'package:church_notes/presentation/theme/view/brightness_button.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 48),
            child: Text(
              'Church Notes',
              style: textTheme.headlineLarge,
            ),
          ),
          const BrightnessTile(),
          const PrivacyPolicyButton(),
          const TermsAndConditionsButton(),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('v1.0.0', style: textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
