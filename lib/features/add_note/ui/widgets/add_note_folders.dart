import 'package:flutter/material.dart';
import 'package:notes_app/features/add_note/logic/add_note_provider.dart';
import 'package:provider/provider.dart';

class AddNoteFolders extends StatelessWidget {
  const AddNoteFolders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddNoteProvider>();
    return Consumer<AddNoteProvider>(
      builder: (context, _, _) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () async {
              provider.changeFolder(provider.folders[index]);
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
                  if (provider.selectedFolder == provider.folders[index])
                    Icon(Icons.check, color: Colors.white),
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
