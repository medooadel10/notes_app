import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/widgets/custom_button.dart';
import 'package:notes_app/widgets/custom_text_form_field.dart';

class AddNoteScreen extends StatefulWidget {
  NoteModel? noteModel;
  int? index;
  AddNoteScreen({Key? key, this.noteModel, this.index}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  List<Color> colors = [
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.deepOrange,
  ];
  int selectedColor = 0;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<FolderModel> folders = [];
  FolderModel? selectedFolder;
  void addNote() async {
    final box = await Hive.openBox<NoteModel>('notes');
    NoteModel note = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      createdAt: DateTime.now().toString(),
      color: colors[selectedColor].value,
      folder: selectedFolder,
    );
    await box.add(note);
    Navigator.pop(context, true);
  }

  void updateNote() async {
    final box = await Hive.openBox<NoteModel>('notes');
    NoteModel note = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      createdAt: widget.noteModel!.createdAt,
      color: colors[selectedColor].value,
      folder: selectedFolder,
    );
    await box.putAt(widget.index!, note);
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteModel?.title ?? '';
    descriptionController.text = widget.noteModel?.description ?? '';
    Color color = colors.singleWhere(
      (element) => element.value == widget.noteModel?.color,
      orElse: () => colors[0],
    );
    setState(() {
      selectedColor = colors.indexOf(color);
    });
    setState(() {
      selectedFolder = widget.noteModel?.folder;
    });
    getFolders();
  }

  void getFolders() async {
    final box = await Hive.openBox<FolderModel>('folders');
    setState(() {
      folders = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Note')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 14,
            children: [
              CustomTextFormField(
                controller: titleController,
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
                controller: descriptionController,
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
                  colors.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = index;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: colors[index],
                      child: selectedColor == index ? Icon(Icons.check) : null,
                    ),
                  ),
                ),
              ),
              CustomButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.noteModel != null) {
                      updateNote();
                    } else {
                      addNote();
                    }
                  }
                },
                text: widget.noteModel == null ? 'Add Note' : 'Edit Note',
              ),

              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFolder = folders[index];
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: folders[index] == selectedFolder ? 0.5 : 1,
                          child: Column(
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.folder,
                                color: Color(folders[index].color),
                                size: 30,
                              ),
                              Text(
                                folders[index].name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedFolder == folders[index])
                          Icon(Icons.check, color: Colors.black, size: 50),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: folders.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
