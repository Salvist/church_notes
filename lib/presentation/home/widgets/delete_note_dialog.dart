import 'package:church_notes/domain/models/note.dart';
import 'package:flutter/material.dart';

class DeleteNoteDialog extends StatelessWidget {
  final Note note;
  final void Function()? onConfirm;

  const DeleteNoteDialog({
    super.key,
    required this.note,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text('Delete ${note.title}?'),
      content: const Text('This note will be permanently deleted'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onConfirm == null
              ? null
              : () {
                  onConfirm!();
                  Navigator.pop(context);
                },
          child: const Text('Confirm'),
        )
      ],
    );
  }
}
