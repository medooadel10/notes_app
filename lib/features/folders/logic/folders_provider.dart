import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/folders/models/folder_model.dart';

class FoldersProvider extends ChangeNotifier {
  List<FolderModel> folders = [];
  void getAllFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    folders = box.values.toList();
    notifyListeners();
  }

  void deleteFolder(int index) async {
    final box = await Hive.openBox<FolderModel>('folders');
    box.deleteAt(index);
    getAllFolders();
  }
}
