import 'package:hive/hive.dart';

import '../../note/model/note.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool done;

  @HiveField(2)
  String? description;

  @HiveField(3)
  int? taskColor;

  @HiveField(4)
  int? created;

  @HiveField(5)
  int? remainder;

  @HiveField(6)
  List<Task>? decendents;

  @HiveField(7)
  bool? isGroupTask;

  @HiveField(9)
  List<int>? attachNotes;

  Task(
      {required this.name,
      this.done = false,
      required this.description,
      required this.taskColor,
      this.remainder,
      this.decendents,
      required this.isGroupTask,
      this.attachNotes})
      : created = DateTime.now().millisecondsSinceEpoch;
}
