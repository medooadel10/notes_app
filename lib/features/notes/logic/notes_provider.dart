import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/notes/models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteModel> notes = [];

  void getAllNotes() async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    notes = box.values.toList();
    notifyListeners();
  }

  void deleteNote(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    box.deleteAt(index);
    getAllNotes();
  }

  void toggleNoteCompletion(int index) async {
    var box = await Hive.openBox<NoteModel>('notesBox');
    var noteModel = notes[index];
    noteModel.isCompleted = !noteModel.isCompleted;
    await box.putAt(index, noteModel);
    getAllNotes();
  }
}
