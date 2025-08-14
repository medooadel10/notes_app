import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/features/folders/models/folder_model.dart';
import 'package:notes_app/features/notes/ui/notes_screen.dart';
import 'package:notes_app/features/notes/models/note_model.dart';
import 'package:notes_app/home_provider.dart';
import 'package:notes_app/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      create: (context) => HomeProvider()..getIsDarkMode(),
      child: Consumer<HomeProvider>(
        builder: (context, _, _) {
          final provider = context.read<HomeProvider>();
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              scaffoldBackgroundColor: provider.isDark
                  ? Colors.black
                  : Colors.white,
              appBarTheme: AppBarTheme(
                color: provider.isDark ? Colors.black : Colors.white,
                iconTheme: IconThemeData(
                  color: provider.isDark ? Colors.white : Colors.black,
                ),
                titleTextStyle: TextStyle(
                  color: provider.isDark ? Colors.white : Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            home: const NotesScreen(),
          );
        },
      ),
    );
  }
}
