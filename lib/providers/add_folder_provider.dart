import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';

class AddFolderProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  int selectedColor = 0;
  List<Color> colors = [
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.deepOrange,
  ];
  final formKey = GlobalKey<FormState>();

  void addFolder(BuildContext context) async {
    final box = await Hive.openBox<FolderModel>('folders');
    var folder = FolderModel(
      name: nameController.text,
      color: colors[selectedColor].value,
      createdAt: DateTime.now().toString(),
    );
    await box.add(folder);
    Navigator.pop(context, true);
  }

  void selectColor(int index) {
    selectedColor = index;
    notifyListeners();
  }
}
