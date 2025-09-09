import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/add_note_screen.dart';
import 'package:notes_app/screens/folders_screen.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:provider/provider.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.read<NotesProvider>();
    return Consumer<NotesProvider>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddNoteScreen()),
              );
              if (result != null && result) {
                provider.getData();
              }
            },
            child: Icon(Icons.add),
          ),
          appBar: AppBar(
            title: Text('Notes'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FoldersScreen()),
                  );
                },
                icon: Icon(Icons.folder),
              ),
              IconButton(
                onPressed: () {
                  provider.toggleDarkMode();
                },
                icon: Icon(Icons.dark_mode),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              spacing: 16,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search for note here...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(width: 3),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {
                          provider.searchForNotes(value);
                        },
                      ),
                    ),
                    DropdownMenuFormField<bool?>(
                      onSelected: (value) {
                        provider.filterNotes(value);
                      },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: null, label: 'All'),
                        DropdownMenuEntry(value: true, label: 'Completed'),
                        DropdownMenuEntry(value: false, label: 'Not Completed'),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final note = provider.filteredNotes == null
                          ? provider.originalNotes[index]
                          : provider.filteredNotes![index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddNoteScreen(noteModel: note, index: index),
                            ),
                          );
                          if (result != null && result) {
                            provider.getData();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Color(note.color),
                                width: 3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: note.isCompleted,
                                onChanged: (value) {
                                  provider.toggleCompletion(index);
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Text(note.description, style: TextStyle()),
                                    Text(
                                      note.createdAt.split(' ')[0],
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      provider.deleteNote(index);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                  if (note.folder != null)
                                    Icon(
                                      Icons.folder,
                                      color: Color(note.folder!.color),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: provider.filteredNotes == null
                        ? provider.originalNotes.length
                        : provider.filteredNotes!.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
