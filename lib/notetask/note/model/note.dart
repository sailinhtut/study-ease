import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  String? image;

  @HiveField(1)
  String caption;

  @HiveField(2)
  String body;

  @HiveField(3)
  int? noteColor;

  @HiveField(4)
  DateTime created;

  @HiveField(5)
  bool? favourite;

  @HiveField(6)
  bool? archieve;

  @HiveField(7)
  DateTime? notificationTime;

  @HiveField(8)
  String? backgroundImage;

  @HiveField(9)
  int? textColor;

  @HiveField(10)
  String? shareImagePath;

  // @HiveField(11)
  // int? isAttachedNote;

  Note(
      {this.image,
      required this.caption,
      required this.body,
      this.noteColor,
      required this.created,
      this.favourite = false,
      this.archieve = false,
      this.notificationTime,
      this.backgroundImage});
}
