import 'package:church_notes/presentation/home/cubit/note_list_cubit.dart';
import 'package:church_notes/presentation/home/widgets/home_drawer.dart';
import 'package:church_notes/presentation/home/widgets/note_list_view.dart';
import 'package:church_notes/presentation/note_editor/view/note_editor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static PageRoute route() {
    return MaterialPageRoute(builder: (context) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Text('Church Notes'),
      ),
      drawer: const HomeDrawer(),
      body: const SafeArea(
        child: NoteListView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final note = await context.read<NoteListCubit>().createNewNote();
          if (!context.mounted) return;
          final editedNote = await Navigator.push(context, NoteEditorPage.route(note));

          if (editedNote == null || !context.mounted) return;
          context.read<NoteListCubit>().updateNote(editedNote);
        },
        label: const Text('New note'),
        icon: const Icon(Icons.note_add),
      ),
    );
  }
}
