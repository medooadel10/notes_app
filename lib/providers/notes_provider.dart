import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesProvider extends ChangeNotifier {
  List<NoteModel> originalNotes = [];
  List<NoteModel>? filteredNotes;

  void getData() async {
    final box = await Hive.openBox<NoteModel>('notes');
    originalNotes = box.values.toList();
    notifyListeners();
  }

  void deleteNote(int index) async {
    final box = await Hive.openBox<NoteModel>('notes');
    box.deleteAt(index);
    getData();
  }

  void toggleCompletion(int index) async {
    final box = await Hive.openBox<NoteModel>('notes');
    final note = originalNotes[index];
    note.isCompleted = !note.isCompleted;
    await box.putAt(index, note);
    getData();
  }

  bool isDark = false;
  void getIsDark() async {
    final prefs = await SharedPreferences.getInstance();
    isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void toggleDarkMode() async {
    isDark = !isDark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', isDark);
    notifyListeners();
  }

  void searchForNotes(String value) {
    if (value.isEmpty) {
      filteredNotes = null;
      notifyListeners();
      return;
    }
    List<NoteModel> notes = originalNotes
        .where(
          (element) =>
              element.title.contains(value) ||
              element.description.contains(value),
        )
        .toList();
    filteredNotes = notes;
    notifyListeners();
  }

  void filterNotes(bool? value) {
    if (value == null) {
      filteredNotes = null;
      notifyListeners();
      return;
    }
    final notes = originalNotes
        .where((element) => element.isCompleted == value)
        .toList();
    filteredNotes = notes;
    notifyListeners();
  }
}
