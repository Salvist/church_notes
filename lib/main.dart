import 'package:church_notes/app.dart';
import 'package:church_notes/data/app_settings_repository.dart';
import 'package:church_notes/data/bible_repository.dart';
import 'package:church_notes/data/note_repository.dart';
import 'package:church_notes/data/source/local/bible_cache.dart';
import 'package:church_notes/data/source/local/local_data_source.dart';
import 'package:church_notes/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper.initDB();

  final bibleCache = BibleCache(db);
  final bibleRepository = BibleRepositoryImpl(db, bibleCache);
  final noteLocalDataSource = NoteLocalDataSource(db);

  final noteRepository = NoteRepositoryImpl(noteLocalDataSource);

  final prefs = SharedPreferencesAsync();
  final appRepository = AppSettingsRepositoryImpl(prefs);

  // To view onboarding
  await prefs.setBool('isOnboardingCompleted', false);

  runApp(
    ChurchNotesApp(
      appRepository: appRepository,
      bibleRepository: bibleRepository,
      noteRepository: noteRepository,
    ),
  );
}
