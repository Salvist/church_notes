import 'package:church_notes/presentation/widgets/dialogs/terms_and_conditions_dialog.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsButton extends StatelessWidget {
  const TermsAndConditionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const TermsAndConditionsDialog(),
        );
      },
      title: const Text('Terms & Conditions'),
    );
  }
}
