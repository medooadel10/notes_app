import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/models/folder_model.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/screens/notes_screen.dart';
import 'package:notes_app/style/app_themes.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(FolderModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotesProvider()
        ..getData()
        ..getIsDark(),
      child: Consumer<NotesProvider>(
        builder: (context, value, child) {
          final provider = context.read<NotesProvider>();
          return MaterialApp(
            title: 'Flutter Demo',
            theme: provider.isDark ? AppThemes.darkTheme : AppThemes.lighTheme,
            home: NotesScreen(),
          );
        },
      ),
    );
  }
}
