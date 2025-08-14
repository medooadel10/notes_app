import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/folders/models/folder_model.dart';

class AddFolderProvider extends ChangeNotifier {
  int? selectedColor;
  final labelController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<Color> colors = [
    Colors.yellow,
    Colors.black,
    Colors.cyan,
    Colors.orangeAccent,
  ];
  void changeColor(index) {
    selectedColor = index;
    notifyListeners();
  }

  void addFolder() async {
    if (formKey.currentState!.validate()) {
      if (selectedColor != null) {
        FolderModel folderModel = FolderModel(
          label: labelController.text,
          color: colors[selectedColor!].value,
          createAt: DateTime.now().toString(),
        );
        final box = await Hive.openBox<FolderModel>('folders');
        box.add(folderModel);
        Fluttertoast.showToast(msg: 'The folder added successfully');
      }
    }
  }
}
