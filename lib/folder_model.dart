import 'package:hive_flutter/hive_flutter.dart';
part 'folder_model.g.dart';

@HiveType(typeId: 1)
class FolderModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int color;
  @HiveField(2)
  final String createdAt;

  FolderModel({
    required this.name,
    required this.color,
    required this.createdAt,
  });
}
