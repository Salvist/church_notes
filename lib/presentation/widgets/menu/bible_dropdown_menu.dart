import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:church_notes/presentation/app_settings/bloc/event.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BibleDropdownMenu extends StatelessWidget {
  const BibleDropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettings>(builder: (context, state) {
      return DropdownMenu<BibleVersion>(
        label: const Text('Bible version'),
        width: double.infinity,
        initialSelection: state.defaultBible,
        onSelected: (value) {
          if (value == null) return;
          context.read<AppSettingsBloc>().add(ChangeDefaultBible(value));
        },
        dropdownMenuEntries: BibleVersion.values.map((version) {
          return DropdownMenuEntry(
            value: version,
            label: '${version.code} (${version.language.label})',
          );
        }).toList(growable: false),
      );
    });
  }
}
