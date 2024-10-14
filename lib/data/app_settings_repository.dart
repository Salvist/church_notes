import 'dart:developer';
import 'dart:ui';

import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/domain/enums/language.dart';
import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeBrightness = 'themeBrightness';
const _isOnboardingCompleted = 'isOnboardingCompleted';

const _appLanguage = 'appLanguage';
const _defaultBible = 'appBible';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final SharedPreferencesAsync _prefs;
  const AppSettingsRepositoryImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    final brightness = await getBrightness();
    final defaultBible = await getDefaultBible();
    final onboardingCompleted = await isOnboardingCompleted();


    return AppSettings(
      status: AppSettingsStatus.loaded,
      brightness: brightness,
      defaultBible: defaultBible,
      isOnboardingCompleted: onboardingCompleted,
    );
  }

  @override
  Future<Brightness> getBrightness() async {
    final value = await _prefs.getString(_themeBrightness);
    if (value == null) {
      final platformBrightness = PlatformDispatcher.instance.platformBrightness;
      await setBrightness(platformBrightness);
      return platformBrightness;
    }
    return Brightness.values.byName(value);
  }

  @override
  Future<void> setBrightness(Brightness brightness) async {
    await _prefs.setString(_themeBrightness, brightness.name);
    log('App theme has been set to ${brightness.name} mode');
  }

  @override
  Future<void> finishOnboarding() async {
    await _prefs.setBool(_isOnboardingCompleted, true);
    log('Onboarding is completed');
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await _prefs.getBool(_isOnboardingCompleted) ?? false;
  }

  @override
  Future<Language> getAppLanguage() async {
    var appLanguage = await _prefs.getString(_appLanguage);
    if (appLanguage == null) await _prefs.setString(_appLanguage, 'english');
    return Language.values.byName(appLanguage ?? 'english');
  }

  @override
  Future<void> setAppLanguage(Language language) async {
    await _prefs.setString(_appLanguage, language.name);
    log('App language has been changed to ${language.label}');
  }

  @override
  Future<BibleVersion> getDefaultBible() async {
    final bibleString = await _prefs.getString(_defaultBible);
    if (bibleString == null) await _prefs.setString(_defaultBible, 'asv');
    return BibleVersion.values.byName(bibleString ?? 'asv');
  }

  @override
  Future<void> setDefaultBible(BibleVersion version) async {
    await _prefs.setString(_defaultBible, version.name);
    log('Default Bible has been set to ${version.code}');
  }
}
