import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/features/add_note/logic/add_note_provider.dart';
import 'package:notes_app/core/widgets/custom_button.dart';
import 'package:notes_app/features/add_note/ui/widgets/add_note_folders.dart';
import 'package:notes_app/features/home/logic/home_provider.dart';
import 'package:notes_app/features/home/models/note_model.dart';
import 'package:provider/provider.dart';

class AddNoteScreen extends StatelessWidget {
  final NoteModel? noteModel;
  final int? index;
  const AddNoteScreen({super.key, this.noteModel, this.index});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNoteProvider()
        ..init(noteModel)
        ..getAllFolders(),
      child: Builder(
        builder: (context) {
          final provider = context.read<AddNoteProvider>();
          return Scaffold(
            appBar: AppBar(title: Text('Add Note')),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: provider.formKey,
                        child: Column(
                          spacing: 16,
                          children: [
                            TextFormField(
                              controller: provider.titleController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelText: 'Enter note title',
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
                                  return 'Please enter a valid title';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            TextFormField(
                              controller: provider.bodyController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                labelText: 'Enter note description',
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid title';
                                }
                                return null;
                              },
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                            ),
                            Consumer<AddNoteProvider>(
                              builder: (context, _, _) {
                                return Row(
                                  children: List.generate(
                                    provider.colors.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 3,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          provider.changeColor(index);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              provider.colors[index],
                                          child: provider.selectedColor == index
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            AddNoteFolders(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    text: noteModel != null ? 'Update Note' : 'Add Note',
                    onPressed: () {
                      if (noteModel != null) {
                        provider.updateNote(noteModel!, index!, context);
                      } else {
                        provider.addNote(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
