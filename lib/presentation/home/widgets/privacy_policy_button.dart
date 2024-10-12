import 'package:church_notes/presentation/widgets/dialogs/privacy_policy_dialog.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyButton extends StatelessWidget {
  const PrivacyPolicyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const PrivacyPolicyDialog(),
        );
      },
      title: const Text('Privacy policy'),
    );
  }
}
