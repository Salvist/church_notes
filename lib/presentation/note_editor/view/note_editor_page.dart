import 'dart:async';
import 'dart:convert';

import 'package:church_notes/domain/models/note.dart';
import 'package:church_notes/domain/repositories/bible_repository.dart';
import 'package:church_notes/domain/repositories/note_repository.dart';
import 'package:church_notes/presentation/note_editor/cubit/note_cubit.dart';
import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_cubit.dart';
import 'package:church_notes/presentation/verse_lookup/cubit/verse_lookup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteEditorPage extends StatelessWidget {
  final Note note;
  const NoteEditorPage({
    super.key,
    required this.note,
  });

  static PageRoute<Note> route(Note note) {
    return MaterialPageRoute<Note>(builder: (context) => NoteEditorPage(note: note));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(
            note,
            context.read<NoteRepository>(),
          ),
        ),
        BlocProvider(create: (context) => VerseLookupCubit(context.read<BibleRepository>())),
      ],
      child: BlocListener<VerseLookupCubit, VerseLookupState>(
        listener: (context, state) {
          if (state == const VerseLookupSuccess()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Verse has been added'),
              ),
            );
          }
        },
        child: const NoteEditorView(),
      ),
    );
  }
}

class NoteEditorView extends StatefulWidget {
  const NoteEditorView({
    super.key,
  });

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  final titleController = TextEditingController();
  final titleFocusNode = FocusNode();

  late final QuillController noteController;
  final noteFocusNode = FocusNode();
  final noteScrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    final note = context.read<NoteCubit>().state;
    titleController.text = note.title;
    titleController.addListener(_noteListener);

    noteController = QuillController(
      selection: const TextSelection.collapsed(offset: 0),
      document: Document.fromJson(jsonDecode(note.content)),
    );
    noteController.addListener(_noteListener);

    super.initState();
  }

  void _noteListener() {
    // Set debounce
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _saveNote);
  }

  Future<void> _saveNote() async {
    final title = titleController.text;
    final content = jsonEncode(noteController.document.toDelta().toJson());

    await context.read<NoteCubit>().updateNote(title: title, content: content);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    titleController.dispose();
    titleFocusNode.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        await _saveNote();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.pop(context, context.read<NoteCubit>().state);
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: titleController,
            focusNode: titleFocusNode,
            style: textTheme.titleLarge,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Tap to edit title...',
              hintStyle: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.4)),
            ),
          ),
          actions: [
            BlocBuilder<VerseLookupCubit, VerseLookupState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          await context.read<VerseLookupCubit>().getPassages(noteController);
                          if (!context.mounted) return;
                          FocusScope.of(context).unfocus();

                          setState(() {});
                        },
                  child: const Text('Get verses'),
                );
              },
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: QuillEditor(
                focusNode: noteFocusNode,
                controller: noteController,
                scrollController: noteScrollController,
                configurations: const QuillEditorConfigurations(
                  padding: EdgeInsets.all(16),
                  placeholder: 'Start typing your note...',
                ),
              ),
            ),
            QuillToolbar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  QuillToolbarToggleStyleButton(
                    attribute: Attribute.bold,
                    controller: noteController,
                  ),
                  QuillToolbarToggleStyleButton(
                    attribute: Attribute.italic,
                    controller: noteController,
                  ),
                  QuillToolbarToggleStyleButton(
                    attribute: Attribute.underline,
                    controller: noteController,
                  ),
                  QuillToolbarToggleStyleButton(
                    attribute: Attribute.strikeThrough,
                    controller: noteController,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: true,
                    controller: noteController,
                  ),
                  QuillToolbarHistoryButton(
                    isUndo: false,
                    controller: noteController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
