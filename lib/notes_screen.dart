import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/add_note_screen.dart';
import 'package:notes_app/folders_screen.dart';
import 'package:notes_app/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NoteModel> notes = [];
  void getData() async {
    final box = await Hive.openBox<NoteModel>('notes');
    setState(() {
      notes = box.values.toList();
    });
  }

  void deleteNote(int index) async {
    final box = await Hive.openBox<NoteModel>('notes');
    box.deleteAt(index);
    getData();
  }

  void toggleCompletion(int index) async {
    final box = await Hive.openBox<NoteModel>('notes');
    final note = notes[index];
    note.isCompleted = !note.isCompleted;
    await box.putAt(index, note);
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
          if (result != null && result) {
            getData();
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Notes'),
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
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddNoteScreen(noteModel: notes[index], index: index),
                ),
              );
              if (result != null && result) {
                getData();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Color(note.color), width: 3),
                ),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: note.isCompleted,
                    onChanged: (value) {
                      toggleCompletion(index);
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Text(note.description),
                        Text(note.createdAt.split(' ')[0]),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          deleteNote(index);
                        },
                        icon: Icon(Icons.delete),
                      ),
                      if (note.folder != null)
                        Icon(Icons.folder, color: Color(note.folder!.color)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 20),
        itemCount: notes.length,
      ),
    );
  }
}
