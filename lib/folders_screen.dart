import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/add_folder_screen.dart';
import 'package:notes_app/folder_model.dart';

class FoldersScreen extends StatefulWidget {
  const FoldersScreen({Key? key}) : super(key: key);

  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  List<FolderModel> folders = [];

  void getFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    setState(() {
      folders = box.values.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getFolders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFolderScreen()),
          );
          if (result != null && result) {
            getFolders();
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Folders')),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(folders[index].color),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                folders[index].name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                folders[index].createdAt.split(' ')[0],
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: folders.length,
      ),
    );
  }
}
