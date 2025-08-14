import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/add_note/ui/add_note_screen.dart';
import 'package:notes_app/features/folders/ui/folders_screen.dart';
import 'package:notes_app/features/home/logic/home_provider.dart';
import 'package:notes_app/features/home/ui/widgets/home_notes_list_view.dart';
import 'package:notes_app/features/home/models/note_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();
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
      body: HomeNotesListView(),
    );
  }
}
