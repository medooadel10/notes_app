import 'package:flutter/material.dart';
import 'package:notes_app/features/notes/logic/notes_provider.dart';
import 'package:notes_app/features/notes/ui/widgets/note_tile.dart';
import 'package:provider/provider.dart';

class NotesListView extends StatelessWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotesProvider>();
    return Consumer<NotesProvider>(
      builder: (context, _, _) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) => NoteTile(index: index),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: provider.notes.length,
        );
      },
    );
  }
}
