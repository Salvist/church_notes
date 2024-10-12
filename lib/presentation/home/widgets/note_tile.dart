import 'package:church_notes/domain/models/note.dart';
import 'package:church_notes/presentation/home/widgets/delete_note_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final void Function()? onTap;
  final void Function()? onDelete;

  const NoteTile({
    super.key,
    required this.note,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yMMMMd').add_jm();
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(note.title.isEmpty ? 'Untitled note' : note.title),
        subtitle: Text(formatter.format(note.createdAt)),
        trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DeleteNoteDialog(
                note: note,
                onConfirm: onDelete,
              ),
            );
          },
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
