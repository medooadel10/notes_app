import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:notes_app/models/note_model.dart';

class AddNoteProvider extends ChangeNotifier {
  List<Color> colors = [
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.deepOrange,
  ];
  int selectedColor = 0;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<FolderModel> folders = [];
  FolderModel? selectedFolder;
  void addNote(BuildContext context) async {
    final box = await Hive.openBox<NoteModel>('notes');
    NoteModel note = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      createdAt: DateTime.now().toString(),
      color: colors[selectedColor].value,
      folder: selectedFolder,
    );
    await box.add(note);
    Navigator.pop(context, true);
  }

  void updateNote(NoteModel noteModel, int index, BuildContext context) async {
    final box = await Hive.openBox<NoteModel>('notes');
    NoteModel note = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      createdAt: noteModel.createdAt,
      color: colors[selectedColor].value,
      folder: selectedFolder,
    );
    await box.putAt(index, note);
    Navigator.pop(context, true);
  }

  void getFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    folders = box.values.toList();
    notifyListeners();
  }

  void selectColor(int index) {
    selectedColor = index;
    notifyListeners();
  }

  void selectFolder(FolderModel folder) {
    selectedFolder = folder;
    notifyListeners();
  }
}
