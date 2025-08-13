import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/add_note_screen.dart';
import 'package:notes_app/note_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NoteModel> notes = [];
  void getAllNotes() async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    setState(() {
      notes = box.values.toList();
    });
  }

  void deleteNote(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    box.deleteAt(index);
    getAllNotes();
  }

  @override
  void initState() {
    super.initState();
    getAllNotes();
  }

  void toggleNoteCompletion(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    var noteModel = notes[index];
    noteModel.isCompleted = !noteModel.isCompleted;
    await box.putAt(index, noteModel);
    getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
          if (result != null && result) {
            getAllNotes();
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNoteScreen(noteModel: notes[index], index: index),
              ),
            );
            if (result != null && result) {
              getAllNotes();
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(notes[index].color),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: notes[index].isCompleted,
                  onChanged: (value) {
                    toggleNoteCompletion(index);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notes[index].title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Text(
                            notes[index].createdAt.toString().split(' ')[0],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notes[index].body,
                              style: TextStyle(color: Colors.white),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: notes.length,
      ),
    );
  }
}
