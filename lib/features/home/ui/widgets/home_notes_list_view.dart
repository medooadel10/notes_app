import 'package:flutter/material.dart';
import 'package:notes_app/features/home/logic/home_provider.dart';
import 'package:notes_app/features/home/ui/widgets/home_note_tile.dart';
import 'package:provider/provider.dart';

class HomeNotesListView extends StatelessWidget {
  const HomeNotesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HomeProvider>();
    return Consumer<HomeProvider>(
      builder: (context, _, _) {
        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) => HomeNoteTile(index: index),
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: provider.notes.length,
        );
      },
    );
  }
}
