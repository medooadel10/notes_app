import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';

class FoldersProvider extends ChangeNotifier {
  List<FolderModel> folders = [];

  void getFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    folders = box.values.toList();
    notifyListeners();
  }
}
