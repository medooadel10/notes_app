import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/add_note/ui/add_note_screen.dart';
import 'package:notes_app/features/folders/ui/folders_screen.dart';
import 'package:notes_app/features/notes/logic/notes_provider.dart';
import 'package:notes_app/features/notes/ui/widgets/notes_list_view.dart';
import 'package:notes_app/features/notes/models/note_model.dart';
import 'package:notes_app/home_provider.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider()..getAllNotes(),
      child: Builder(
        builder: (context) {
          final provider = context.read<NotesProvider>();
          return Scaffold(
            appBar: AppBar(
              title: Text('Home'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FoldersScreen()),
                    );
                  },
                  icon: Icon(Icons.folder),
                ),
                IconButton(
                  onPressed: () {
                    context.read<HomeProvider>().changeDarkMode();
                  },
                  icon: Icon(Icons.dark_mode),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()),
                );
                if (result != null && result) {
                  provider.getAllNotes();
                }
              },
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
            ),
            body: NotesListView(),
          );
        },
      ),
    );
  }
}
