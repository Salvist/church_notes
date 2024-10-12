import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:church_notes/presentation/theme/bloc/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  final AppSettingsRepository _appRepository;
  ThemeBloc(this._appRepository, Brightness brightness) : super(_getTheme(brightness: brightness)) {
    on<ToggleBrightness>(_onToggleBrightness);
  }

  void _onToggleBrightness(ToggleBrightness event, Emitter<ThemeData> emit) {
    final newBrightness = state.brightness == Brightness.light ? Brightness.dark : Brightness.light;
    final newTheme = _getTheme(brightness: newBrightness);
    _appRepository.setBrightness(newBrightness);
    emit(newTheme);
  }

  static ThemeData _getTheme({
    Brightness? brightness,
  }) {
    return ThemeData(
      brightness: brightness,
      fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}
