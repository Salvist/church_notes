import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  const TermsAndConditionsDialog({super.key});

  @override
  State<TermsAndConditionsDialog> createState() => _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  late final Future<String> _termsAndConditions;

  @override
  void initState() {
    _termsAndConditions = DefaultAssetBundle.of(context).loadString('terms_and_conditions.md');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: _termsAndConditions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final privacyPolicy = snapshot.requireData;
            return Markdown(data: privacyPolicy);
          } else if (snapshot.hasError) {
            return const Text('Failed to load privacy policy');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
