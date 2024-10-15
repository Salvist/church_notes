import 'package:church_notes/presentation/onboarding/2_how_to/view/how_to_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static PageRoute route() {
    return MaterialPageRoute(builder: (context) => const WelcomePage());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text('Welcome to', style: textTheme.headlineLarge),
              const SizedBox(height: 16),
              Text('Church Notes', style: GoogleFonts.pacifico(fontSize: textTheme.displayLarge?.fontSize)),
              const SizedBox(height: 16),
              Text(
                'An innovative note-taking app that enriches your notes with Bible verses.',
                style: textTheme.titleLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, HowToPage.route());
                  },
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
