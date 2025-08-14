import 'package:flutter/material.dart';
import 'package:notes_app/features/add_folder/logic/add_folder_provider.dart';
import 'package:notes_app/features/add_folder/ui/widgets/add_folder_form.dart';
import 'package:notes_app/features/add_folder/ui/widgets/add_folder_submit.dart';
import 'package:provider/provider.dart';

class AddFolderScreen extends StatelessWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFolderProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Add Folder')),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: AddFolderForm())),
              AddFolderSubmit(),
            ],
          ),
        ),
      ),
    );
  }
}
