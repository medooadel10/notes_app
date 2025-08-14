import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/folders/models/folder_model.dart';
import 'package:notes_app/features/notes/models/note_model.dart';

class AddNoteProvider extends ChangeNotifier {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green,
  ];
  int? selectedColor;

  void init(NoteModel? noteModel) {
    titleController.text = noteModel?.title ?? '';
    bodyController.text = noteModel?.body ?? '';
    if (noteModel != null) {
      selectedColor = colors.indexWhere(
        (element) => element.value == noteModel.color,
      );
    }
  }

  void changeColor(int index) {
    selectedColor = index;
    notifyListeners();
  }

  void addNote(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedColor != null) {
        final box = await Hive.openBox<NoteModel>('notesBox');
        NoteModel noteModel = NoteModel(
          title: titleController.text,
          body: bodyController.text,
          createdAt: DateTime.now(),
          color: colors[selectedColor!].value,
          folder: selectedFolder,
        );
        print('Is Completed ${noteModel.isCompleted}');
        await box.add(noteModel);
        Fluttertoast.showToast(msg: 'The note created successfully');
        Navigator.pop(context, true);
      }
    }
  }

  void updateNote(NoteModel note, int index, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedColor != null) {
        final box = await Hive.openBox<NoteModel>('notesBox');
        NoteModel noteModel = NoteModel(
          title: titleController.text,
          body: bodyController.text,
          createdAt: note.createdAt,
          color: colors[selectedColor!].value,
          folder: selectedFolder,
        );
        box.putAt(index, noteModel);
        Fluttertoast.showToast(msg: 'The note updated successfully');
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: 'Please select a color');
      }
    }
  }

  List<FolderModel> folders = [];
  void getAllFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    folders = box.values.toList();
    notifyListeners();
  }

  FolderModel? selectedFolder;
  void changeFolder(FolderModel folder) {
    selectedFolder = folder;
    notifyListeners();
  }
}
