import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/note_model.dart';

class AddNoteScreen extends StatefulWidget {
  final NoteModel? noteModel;
  final int? index;
  const AddNoteScreen({super.key, this.noteModel, this.index});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.purple,
    Colors.green,
  ];
  int? selectedColor;

  void addNote() async {
    final box = await Hive.openBox<NoteModel>('notesBox');
    NoteModel noteModel = NoteModel(
      title: titleController.text,
      body: bodyController.text,
      createdAt: DateTime.now(),
      color: colors[selectedColor!].value,
    );
    print('Is Completed ${noteModel.isCompleted}');
    await box.add(noteModel);
    Fluttertoast.showToast(msg: 'The note created successfully');
    Navigator.pop(context, true);
  }

  void updateNote() async {
    final box = await Hive.openBox<NoteModel>('notesBox');
    NoteModel noteModel = NoteModel(
      title: titleController.text,
      body: bodyController.text,
      createdAt: widget.noteModel!.createdAt,
      color: colors[selectedColor!].value,
    );
    box.putAt(widget.index!, noteModel);
    Fluttertoast.showToast(msg: 'The note updated successfully');
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteModel?.title ?? '';
    bodyController.text = widget.noteModel?.body ?? '';
    if (widget.noteModel != null) {
      selectedColor = colors.indexWhere(
        (element) => element.value == widget.noteModel?.color,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      TextFormField(
                        controller: titleController,
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
                        controller: bodyController,
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
                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      Row(
                        children: List.generate(
                          colors.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = index;
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: colors[index],
                                child: selectedColor == index
                                    ? Icon(Icons.check, color: Colors.white)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: MaterialButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (selectedColor != null) {
                      if (widget.noteModel != null) {
                        updateNote();
                      } else {
                        addNote();
                      }
                    } else {
                      Fluttertoast.showToast(msg: 'Please select a color');
                    }
                  }
                },
                child: Text(
                  widget.noteModel != null ? 'Update Note' : 'Add Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
