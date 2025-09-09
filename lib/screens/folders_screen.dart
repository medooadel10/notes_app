import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/providers/folders_provider.dart';
import 'package:notes_app/screens/add_folder_screen.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:provider/provider.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FoldersProvider()..getFolders(),
      builder: (context, child) {
        final provider = context.read<FoldersProvider>();
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddFolderScreen()),
              );
              if (result != null && result) {
                provider.getFolders();
              }
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(title: Text('Folders')),
          body: Consumer<FoldersProvider>(
            builder: (context, value, child) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(provider.folders[index].color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.folders[index].name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        provider.folders[index].createdAt.split(' ')[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemCount: provider.folders.length,
              );
            },
          ),
        );
      },
    );
  }
}
