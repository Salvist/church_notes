import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';
import 'package:church_notes/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:church_notes/presentation/home/cubit/note_list_cubit.dart';
import 'package:church_notes/presentation/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ChurchNotesApp extends StatelessWidget {
  final AppSettingsRepository appRepository;
  final BibleRepository bibleRepository;
  final NoteRepository noteRepository;

  const ChurchNotesApp({
    super.key,
    required this.appRepository,
    required this.bibleRepository,
    required this.noteRepository,
  });

  ThemeData _getTheme({
    Brightness? brightness,
  }) {
    return ThemeData(
      brightness: brightness,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

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
          BlocProvider<AppSettingsBloc>(
              create: (context) => AppSettingsBloc(appRepository)),
          BlocProvider<NoteListCubit>(
              create: (context) => NoteListCubit(noteRepository)),
        ],
        child: BlocBuilder<AppSettingsBloc, AppSettings>(
            builder: (context, settings) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Church Notes App',
            theme: _getTheme(brightness: settings.brightness),
            home: const SplashPage(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FlutterQuillLocalizations.delegate,
            ],
          );
        }),
      ),
    );
  }
}
