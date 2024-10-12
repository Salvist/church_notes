import 'package:church_notes/presentation/home/widgets/privacy_policy_button.dart';
import 'package:church_notes/presentation/home/widgets/terms_and_conditions_button.dart';
import 'package:church_notes/presentation/onboarding/widgets/onboarding_scaffold.dart';
import 'package:church_notes/presentation/theme/view/brightness_button.dart';
import 'package:church_notes/presentation/widgets/church_note_text.dart';
import 'package:flutter/material.dart';

class AgreementsPage extends StatelessWidget {
  const AgreementsPage({super.key});

  static PageRoute route() {
    return MaterialPageRoute(
      builder: (context) => const AgreementsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ChurchNotesText(),
            const SizedBox(height: 24),
            const Text('That\'s all on how to use Church Notes!'),
            const SizedBox(height: 32),
            const Text('Change the app\'s theme by tapping '),
            const BrightnessTile(),
            const SizedBox(height: 64),
            const Text('By continuing, you agree to our privacy policy and terms & conditions below'),
            const PrivacyPolicyButton(),
            const TermsAndConditionsButton(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Sounds good!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
