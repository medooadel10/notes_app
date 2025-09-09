import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:notes_app/providers/add_folder_provider.dart';
import 'package:notes_app/widgets/custom_button.dart';
import 'package:notes_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class AddFolderScreen extends StatelessWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddFolderProvider(),
      builder: (context, child) {
        final provider = context.read<AddFolderProvider>();
        return Scaffold(
          appBar: AppBar(title: Text('Add Folder')),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Form(
              key: provider.formKey,
              child: Column(
                spacing: 16,
                children: [
                  CustomTextFormField(
                    controller: provider.nameController,
                    hintText: 'Enter folder name',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter folder name';
                      }
                      return null;
                    },
                  ),
                  Consumer<AddFolderProvider>(
                    builder: (context, value, child) {
                      return Row(
                        spacing: 10,
                        children: List.generate(
                          provider.colors.length,
                          (index) => GestureDetector(
                            onTap: () {
                              provider.selectColor(index);
                            },
                            child: CircleAvatar(
                              backgroundColor: provider.colors[index],
                              child: provider.selectedColor == index
                                  ? Icon(Icons.check)
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  CustomButton(
                    onPressed: () {
                      if (provider.formKey.currentState!.validate()) {
                        provider.addFolder(context);
                      }
                    },
                    text: 'Add Folder',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
