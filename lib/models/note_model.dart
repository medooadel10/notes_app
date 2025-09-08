import 'package:hive/hive.dart';
import 'package:notes_app/models/folder_model.dart';
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String createdAt;
  @HiveField(3)
  final int color;
  @HiveField(4)
  bool isCompleted;
  @HiveField(5)
  final FolderModel? folder;

  NoteModel({
    required this.title,
    required this.description,
    required this.createdAt,
    required this.color,
    this.isCompleted = false,
    this.folder,
  });
}
