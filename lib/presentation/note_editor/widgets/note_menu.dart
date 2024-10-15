import 'package:church_notes/presentation/note_editor/widgets/change_bible_dialog.dart';
import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteMenu extends StatelessWidget {
  final QuillController controller;

  const NoteMenu({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          child: const Text('Get verses'),
          onPressed: () async {
            await context.read<VerseLookupCubit>().getPassages(controller);
            if (!context.mounted) return;
            FocusScope.of(context).unfocus();
          },
        ),
        MenuItemButton(
          child: const Text('Change bible'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const ChangeBibleDialog();
              },
            );
          },
        ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_vert),
        );
      },
    );
  }
}
