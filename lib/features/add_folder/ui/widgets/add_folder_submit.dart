import 'package:flutter/material.dart';
import 'package:notes_app/features/add_folder/logic/add_folder_provider.dart';
import 'package:notes_app/core/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddFolderSubmit extends StatelessWidget {
  const AddFolderSubmit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddFolderProvider>();
    return CustomButton(
      text: 'Add Folder',
      onPressed: () {
        provider.addFolder();
      },
    );
  }
}
