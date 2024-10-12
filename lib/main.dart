import 'package:church_notes/app.dart';
import 'package:church_notes/data/app_settings_repository.dart';
import 'package:church_notes/data/bible_repository.dart';
import 'package:church_notes/data/note_repository.dart';
import 'package:church_notes/data/source/local/local_data_source.dart';
import 'package:church_notes/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper.initDB();

  final bibleRepository = BibleRepositoryImpl(db);
  final noteLocalDataSource = NoteLocalDataSource(db);

  final noteRepository = NoteRepositoryImpl(noteLocalDataSource);

  final prefs = SharedPreferencesAsync();
  final appRepository = AppSettingsRepositoryImpl(prefs);
  await appRepository.setBrightness(Brightness.dark);
  final brightness = await appRepository.getBrightness();

  runApp(
    ChurchNotesApp(
      appRepository: appRepository,
      bibleRepository: bibleRepository,
      noteRepository: noteRepository,
      brightness: brightness,
    ),
  );
}
