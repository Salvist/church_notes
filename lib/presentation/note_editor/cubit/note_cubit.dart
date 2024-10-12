import 'package:church_notes/domain/models/note.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteCubit extends Cubit<Note> {
  final NoteRepository _noteRepository;
  NoteCubit(
    super.initialState,
    this._noteRepository,
  );

  Future<void> updateNote({String? title, String? content}) async {
    final updatedNote = state.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
    );

    if (updatedNote != state) {
      await _noteRepository.updateNote(updatedNote);
      emit(updatedNote);
    }
  }
}
