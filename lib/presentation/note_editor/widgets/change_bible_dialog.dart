import 'package:church_notes/domain/enums/bible_version.dart';
import 'package:church_notes/presentation/app_settings/bloc/app_settings_bloc.dart';
import 'package:church_notes/presentation/app_settings/bloc/event.dart';
import 'package:church_notes/presentation/app_settings/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeBibleDialog extends StatelessWidget {
  const ChangeBibleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change default bible'),
      content: SizedBox(
        width: 400,
        child: BlocBuilder<AppSettingsBloc, AppSettings>(
          builder: (context, settings) {
            return ListView(
              shrinkWrap: true,
              children: BibleVersion.values.map((version) {
                return RadioListTile(
                  value: version,
                  groupValue: settings.defaultBible,
                  onChanged: (value) {
                    context.read<AppSettingsBloc>().add(ChangeDefaultBible(version));
                  },
                  title: Text(version.code),
                );
              }).toList(growable: false),
            );
          }
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('Done'),
        )
      ],
    );
  }
}
