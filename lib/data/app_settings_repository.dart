import 'dart:developer';
import 'dart:ui';

import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeBrightness = 'themeBrightness';
const _didOnboarding = 'onboardingCompleted';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final SharedPreferencesAsync _prefs;
  const AppSettingsRepositoryImpl(this._prefs);

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
    await _prefs.setBool(_didOnboarding, true);
    log('Onboarding is completed');
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await _prefs.getBool(_didOnboarding) ?? false;
  }
}
