import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  const PrivacyPolicyDialog({super.key});

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  late final Future<String> _privacyPolicy;

  @override
  void initState() {
    _privacyPolicy = DefaultAssetBundle.of(
      context,
    ).loadString('privacy_policy.md');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: _privacyPolicy,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final privacyPolicy = snapshot.requireData;
            return Column(
              children: [
                Expanded(child: Markdown(data: privacyPolicy)),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
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
