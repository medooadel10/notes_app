import 'package:flutter/material.dart';
import 'package:notes_app/features/folders/logic/folders_provider.dart';
import 'package:provider/provider.dart';

class FoldersListView extends StatelessWidget {
  const FoldersListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<FoldersProvider>();
    return Consumer<FoldersProvider>(
      builder: (context, _, _) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              // final result = await Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         AddNoteScreen(noteModel: provider.notes[index], index: index),
              //   ),
              // );
              // if (result != null && result) {
              //   provider.getAllNotes();
              // }
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(provider.folders[index].color),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.folders[index].label,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      provider.deleteFolder(index);
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: provider.folders.length,
        );
      },
    );
  }
}
