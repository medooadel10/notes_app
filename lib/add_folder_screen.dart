import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/folder_model.dart';

class AddFolderScreen extends StatefulWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  _AddFolderScreenState createState() => _AddFolderScreenState();
}

class _AddFolderScreenState extends State<AddFolderScreen> {
  final nameController = TextEditingController();
  int selectedColor = 0;
  List<Color> colors = [
    Colors.purple,
    Colors.blue,
    Colors.red,
    Colors.deepOrange,
  ];
  final formKey = GlobalKey<FormState>();

  void addFolder() async {
    final box = await Hive.openBox<FolderModel>('folders');
    var folder = FolderModel(
      name: nameController.text,
      color: colors[selectedColor].value,
      createdAt: DateTime.now().toString(),
    );
    await box.add(folder);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Folder')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 16,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter folder name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter folder name';
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
                    addFolder();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Folder',
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
