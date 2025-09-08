import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/note_model.dart';

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

  void addNote() async {
    final box = await Hive.openBox<NoteModel>('notes');
    NoteModel note = NoteModel(
      title: titleController.text,
      description: descriptionController.text,
      createdAt: DateTime.now().toString(),
      color: colors[selectedColor].value,
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
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter note title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter note title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter note description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.noteModel != null) {
                      updateNote();
                    } else {
                      addNote();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.noteModel == null ? 'Add Note' : 'Edit Note',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
