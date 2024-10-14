import 'dart:ui';

import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/enums/language.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';

abstract interface class AppSettingsRepository {
  Future<AppSettings> getSettings();

  /// Get the app theme brightness.
  /// If no brightness is found, it will use platform brightness instead
  Future<Brightness> getBrightness();
  Future<void> setBrightness(Brightness brightness);

  Future<bool> isOnboardingCompleted();
  Future<void> finishOnboarding();

  Future<Language> getAppLanguage();
  Future<void> setAppLanguage(Language language);

  Future<BibleVersion> getDefaultBible();
  Future<void> setDefaultBible(BibleVersion version);

}
