import 'dart:ui';

import 'package:church_notes/domain/repositories/app_settings.dart';
import 'package:church_notes/presentation/app_settings/bloc/event.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettings> {
  final AppSettingsRepository _appRepository;

  AppSettingsBloc(this._appRepository) : super(const AppSettings()) {
    on<ChangeDefaultBible>(_onChangeDefaultBible);
    on<ToggleBrightness>(_onToggleBrightness);
    on<InitializeAppSettings>(_onInitialize);
  }

  void _onInitialize(InitializeAppSettings event, Emitter<AppSettings> emit) async {
    final settings = await _appRepository.getSettings();
    emit(settings);
  }

  void _onToggleBrightness(ToggleBrightness event, Emitter<AppSettings> emit) async {
    final newBrightness = state.brightness == Brightness.light ? Brightness.dark : Brightness.light;
    _appRepository.setBrightness(newBrightness);
    emit(state.copyWith(brightness: newBrightness));
  }

  void _onChangeDefaultBible(ChangeDefaultBible event, Emitter<AppSettings> emit) async {
    _appRepository.setDefaultBible(event.version);
    emit(state.copyWith(bibleVersion: event.version));
  }

}
