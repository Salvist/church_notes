import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:flutter/foundation.dart';

enum AppSettingsStatus { loading, loaded }

class AppSettings {
  final AppSettingsStatus status;
  final Brightness brightness;
  final BibleVersion defaultBible;
  final bool isOnboardingCompleted;

  const AppSettings({
    this.status = AppSettingsStatus.loading,
    this.brightness = Brightness.light,
    this.defaultBible = BibleVersion.asv,
    this.isOnboardingCompleted = false,
  });

  AppSettings copyWith({
    AppSettingsStatus? status,
    Brightness? brightness,
    BibleVersion? bibleVersion,
    bool? isOnboardingCompleted,
  }) {
    return AppSettings(
      status: status ?? this.status,
      brightness: brightness ?? this.brightness,
      defaultBible: bibleVersion ?? defaultBible,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }
}
