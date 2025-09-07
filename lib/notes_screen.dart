import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/add_note_screen.dart';
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
          print(result);
          if (result != null && result) {
            getData();
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Notes')),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        itemBuilder: (context, index) {
          final note = notes[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Color(note.color),
              borderRadius: BorderRadius.circular(12),
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text(
                        note.description,
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        note.createdAt.split(' ')[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteNote(index);
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: notes.length,
      ),
    );
  }
}
