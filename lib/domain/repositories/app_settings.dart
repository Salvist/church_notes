import 'dart:ui';

abstract interface class AppSettingsRepository {
  /// Get the app theme brightness.
  /// If no brightness is found, it will use platform brightness instead
  Future<Brightness> getBrightness();
  Future<void> setBrightness(Brightness brightness);

  Future<bool> isOnboardingCompleted();
  Future<void> finishOnboarding();
}
