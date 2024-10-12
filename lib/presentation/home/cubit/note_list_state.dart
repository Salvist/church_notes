import 'package:church_notes/domain/models/note.dart';
import 'package:equatable/equatable.dart';

enum NoteListStatus { loading, success, failure }

class NoteListState extends Equatable {
  final NoteListStatus status;
  final List<Note> notes;
  final Object? error;

  const NoteListState({
    this.status = NoteListStatus.loading,
    this.notes = const <Note>[],
    this.error,
  });

  NoteListState copyWith({
    NoteListStatus? status,
    List<Note>? notes,
    Object? error,
  }) {
    return NoteListState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, notes];
}
