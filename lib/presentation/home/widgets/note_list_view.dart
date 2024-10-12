import 'package:church_notes/presentation/home/cubit/note_list_cubit.dart';
import 'package:church_notes/presentation/home/cubit/note_list_state.dart';
import 'package:church_notes/presentation/home/widgets/note_tile.dart';
import 'package:church_notes/presentation/note_editor/view/note_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteListCubit, NoteListState>(
      builder: (context, state) {
        final notes = state.notes;
        if (notes.isEmpty) {
          return const ListTile(
            title: Text('Start adding note by tapping "New note" below'),
          );
        } else {
          return ListView.builder(
            // padding: const EdgeInsets.all(16),
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return NoteTile(
                note: note,
                onTap: () async {
                  final editedNote = await Navigator.push(context, NoteEditorPage.route(note));

                  if (editedNote == null || !context.mounted) return;
                  context.read<NoteListCubit>().updateNote(editedNote);
                },
                onDelete: () {
                  context.read<NoteListCubit>().deleteNote(note);
                },
              );
            },
          );
        }
      },
    );
  }
}
