import 'package:church_notes/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:church_notes/presentation/app_settings/bloc/event.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:church_notes/presentation/home/view/home_page.dart';
import 'package:church_notes/presentation/onboarding/1_welcome/welcome_page.dart';
import 'package:church_notes/presentation/widgets/church_note_icon.dart';
import 'package:church_notes/presentation/widgets/church_note_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read<AppSettingsBloc>().add(const InitializeAppSettings());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppSettingsBloc, AppSettings>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, settings) {
        if (settings.isOnboardingCompleted) {
          Navigator.push(context, HomePage.route());
        } else {
          Navigator.push(context, WelcomePage.route());
        }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChurchNoteIcon(),
              SizedBox(height: 32),
              ChurchNotesText(),
            ],
          ),
        ),
      ),
    );
  }
}
