import 'package:church_notes/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:church_notes/presentation/app_settings/bloc/event.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrightnessTile extends StatelessWidget {
  const BrightnessTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppSettingsBloc, AppSettings, Brightness>(
      selector: (state) => state.brightness,
      builder: (context, brightness) {
        final isLight = brightness == Brightness.light;
        final brightnessIcon = isLight ? const Icon(Icons.light_mode) : const Icon(Icons.dark_mode);
        return ListTile(
          onTap: () {
            context.read<AppSettingsBloc>().add(const ToggleBrightness());
          },
          title: Text(isLight ? 'Light mode' : 'Dark mode'),
          trailing: brightnessIcon,
        );
      },
    );
  }
}
