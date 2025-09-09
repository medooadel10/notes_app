import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/providers/add_note_provider.dart';
import 'package:notes_app/widgets/custom_button.dart';
import 'package:notes_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatelessWidget {
  final NoteModel? noteModel;
  final int? index;
  AddNoteScreen({this.noteModel, this.index});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNoteProvider()..getFolders(),
      builder: (context, child) {
        final provider = context.read<AddNoteProvider>();
        return Consumer<AddNoteProvider>(
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(title: Text('Add Note')),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: provider.formKey,
                  child: Column(
                    spacing: 14,
                    children: [
                      CustomTextFormField(
                        controller: provider.titleController,
                        hintText: 'Enter note title',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter note title';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        controller: provider.descriptionController,
                        hintText: 'Enter note description',
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter note description';
                          }
                          return null;
                        },
                      ),
                      Row(
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
                      ),
                      CustomButton(
                        onPressed: () {
                          if (provider.formKey.currentState!.validate()) {
                            if (noteModel != null) {
                              provider.updateNote(noteModel!, index!, context);
                            } else {
                              provider.addNote(context);
                            }
                          }
                        },
                        text: noteModel == null ? 'Add Note' : 'Edit Note',
                      ),

                      SizedBox(
                        height: 70,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              provider.selectFolder(provider.folders[index]);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Opacity(
                                  opacity:
                                      provider.folders[index] ==
                                          provider.selectedFolder
                                      ? 0.5
                                      : 1,
                                  child: Column(
                                    spacing: 5,
                                    children: [
                                      Icon(
                                        Icons.folder,
                                        color: Color(
                                          provider.folders[index].color,
                                        ),
                                        size: 30,
                                      ),
                                      Text(
                                        provider.folders[index].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (provider.selectedFolder ==
                                    provider.folders[index])
                                  Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                              ],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          itemCount: provider.folders.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
