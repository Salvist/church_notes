import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';
import 'package:church_notes/presentation/home/cubit/note_list_cubit.dart';
import 'package:church_notes/presentation/home/view/home_page.dart';
import 'package:church_notes/presentation/onboarding/1_welcome/1_welcome_page.dart';
import 'package:church_notes/presentation/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChurchNotesApp extends StatelessWidget {
  final AppSettingsRepository appRepository;
  final BibleRepository bibleRepository;
  final NoteRepository noteRepository;
  final Brightness brightness;

  const ChurchNotesApp({
    super.key,
    required this.appRepository,
    required this.bibleRepository,
    required this.noteRepository,
    this.brightness = Brightness.light,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AppSettingsRepository>.value(value: appRepository),
        RepositoryProvider<BibleRepository>.value(value: bibleRepository),
        RepositoryProvider<NoteRepository>.value(value: noteRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (context) => ThemeBloc(appRepository, brightness)),
          BlocProvider<NoteListCubit>(create: (context) => NoteListCubit(noteRepository)),
        ],
        child: BlocBuilder<ThemeBloc, ThemeData>(
          builder: (context, theme) {
            return MaterialApp(
              title: 'Church Notes App',
              theme: theme,
              // home: const HomePage(),
              home: const WelcomePage(),
            );
          },
        ),
      ),
    );
  }
}
