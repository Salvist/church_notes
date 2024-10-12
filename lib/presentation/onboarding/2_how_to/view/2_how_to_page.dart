import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/cubit/passage_cubit.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/cubit/passage_state.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/widgets/get_verses_example.dart';
import 'package:church_notes/presentation/onboarding/2_how_to/widgets/note_container.dart';
import 'package:church_notes/presentation/onboarding/3_agreements/view/agreements_page.dart';
import 'package:church_notes/presentation/widgets/church_note_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HowToPage extends StatelessWidget {
  const HowToPage({super.key});

  static PageRoute route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<PassageCubit>(
        create: (context) => PassageCubit(context.read<BibleRepository>()),
        child: const HowToPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ChurchNotesText(),
                    const SizedBox(height: 16),
                    Text('How does it work?', style: textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    const Text('Refer bible verse on your note like so and tap "Get verses"'),
                    const SizedBox(height: 8),
                    const GetVersesExample(),
                    const SizedBox(height: 8),
                    const Text('You can also get multiple verses: Genesis 1:1-7'),
                    const SizedBox(height: 24),
                    const Text(
                      'When referring a Bible verse, make sure it\'s on its own line with '
                      'no additional text on the same line or directly below it.',
                    ),
                    const SizedBox(height: 8),
                    const NoteContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('As we see on Jeremiah 29:11, ...'),
                          Icon(Icons.clear, color: Colors.red),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const NoteContainer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Jeremiah 29:11\nI will remember this!'),
                          Icon(Icons.clear, color: Colors.red),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Unless you don\'t need to pull the verses, then feel free to do so!'),
                    const SizedBox(height: 16),
                    Text('Currently supported Bible(s):', style: textTheme.titleLarge),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text('- ASV (English)', style: textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, AgreementsPage.route());
                },
                child: const Text('Okay, I understand!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
