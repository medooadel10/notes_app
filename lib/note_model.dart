import 'package:hive/hive.dart';

// Generated Code
part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final int color;
  @HiveField(4)
  bool isCompleted;

  NoteModel({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.color,
    this.isCompleted = false,
  });
}
