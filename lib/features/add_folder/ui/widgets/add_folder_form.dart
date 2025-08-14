import 'package:flutter/material.dart';
import 'package:notes_app/features/add_folder/logic/add_folder_provider.dart';
import 'package:provider/provider.dart';

class AddFolderForm extends StatelessWidget {
  const AddFolderForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddFolderProvider>();
    return Form(
      key: provider.formKey,
      child: Column(
        spacing: 16,
        children: [
          TextFormField(
            controller: provider.labelController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              labelText: 'Enter folder label',
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid label';
              }
              return null;
            },
            keyboardType: TextInputType.text,
          ),
          Consumer<AddFolderProvider>(
            builder: (context, _, _) {
              return Row(
                children: List.generate(
                  provider.colors.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () {
                        provider.changeColor(index);
                      },
                      child: CircleAvatar(
                        backgroundColor: provider.colors[index],
                        child: provider.selectedColor == index
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
