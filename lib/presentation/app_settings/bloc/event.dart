import 'dart:ui';

import 'package:church_notes/domain/enums/bible_version.dart';

sealed class AppSettingsEvent {
  const AppSettingsEvent();
}

class InitializeAppSettings extends AppSettingsEvent {
  const InitializeAppSettings();
}

class ToggleBrightness extends AppSettingsEvent {
  const ToggleBrightness();
}

class ChangeDefaultBible extends AppSettingsEvent {
  final BibleVersion version;
  const ChangeDefaultBible(this.version);
}
