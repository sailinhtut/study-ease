import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/notetask/note/screens/note_write_page.dart';
import 'package:notetask/notetask/note/screens/note_write_temp.dart';
import '../../../main.dart';
import '../../../services/audio_services.dart';
import '../model/task.dart';
import '../screens/task_edit.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.taskKey,
  });

  final Task task;
  final int taskKey;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: task.attachNotes != null ? 0.4 : 0.3,
          motion: const DrawerMotion(),
          children: [
            if (task.attachNotes != null && task.attachNotes!.isNotEmpty)
              SlidableAction(
                backgroundColor: Colors.transparent,
                onPressed: (ctx) {
                  final firstAttachedNote =
                      attachedNotes.get(task.attachNotes!.first);
                  NoteWrite(
                    note: firstAttachedNote!,
                    noteKey: task.attachNotes!.first,
                    isAttachedNote: true,
                  
                  ).launch(context,
                      pageRouteAnimation: PageRouteAnimation.Scale);
                },
                foregroundColor:
                    Color(task.taskColor ?? Colors.grey.value).withOpacity(0.7),
                icon: Icons.insert_drive_file_outlined,
              ),
            SlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (ctx) {
                TaskEdit(
                  task: task,
                  taskKey: taskKey,
                ).launch(context);
              },
              foregroundColor: Colors.grey,
              icon: Icons.edit,
            ),
            SlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (ctx) {
                showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("Confirm"),
                          shape: dialogShape(15),
                          content:
                              Text("Are you sure to delete ${task.name} ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (task.attachNotes != null) {
                                    for (var key in task.attachNotes!) {
                                      attachedNotes.delete(key);
                                    }
                                  }
                                  tasks.delete(taskKey);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Color(task.taskColor ??
                                          context.primaryColor.value)),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel",
                                    style: TextStyle(
                                        color: Color(task.taskColor ??
                                            context.primaryColor.value)))),
                          ],
                        ));
              },
              foregroundColor: Colors.grey,
              icon: Icons.delete,
            ),
          ]),
      child: Card(
        // elevation: 10,
        // shadowColor: widget.isInEditMode
        //     ? Colors.black
        //     : Color(currentBox.taskColor ??
        //         Colors.tealAccent.value),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: appState.withBackground.value
            ? Colors.black.withOpacity(0.6)
            : null,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color:
                            Color(task.taskColor ?? Colors.transparent.value),
                        width: 3))),
            child: ListTile(
                title: Text(task.name,
                    style: TextStyle(
                        decoration: task.done
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
                leading: Checkbox(
                  value: task.done,
                  activeColor: Color(task.taskColor ?? Colors.green.value),
                  shape: RoundedRectangleBorder(borderRadius: radius(3)),
                  onChanged: (value) async {
                    task.done = value!;
                    if (task.done) {
                      await AudioService.instance.ding();
                    } else {
                      await AudioService.instance.unding();
                    }
                    tasks.put(taskKey, task);
                  },
                ),
                trailing: task.done
                    ? Text(
                        language.completed,
                        style: secondaryTextStyle(size: 10),
                      )
                    : null
                // PopupMenuButton(
                //     onSelected: (value) {
                //       if (value == 0) {
                //         // edit
                //         TaskEdit(task: task, taskKey: taskKey).launch(
                //             context,
                //             pageRouteAnimation: PageRouteAnimation.Slide);
                //       } else if (value == 1) {
                //         // remove
                //         tasks.delete(taskKey);
                //       } else {
                //         // nothing
                //       }
                //     },
                //     itemBuilder: (ctx) => const [
                //           PopupMenuItem(
                //             value: 0,
                //             child: Text("Edit"),
                //           ),
                //           PopupMenuItem(
                //             value: 1,
                //             child: Text("Remove"),
                //           ),
                //         ],
                //     icon: const Icon(Icons.more_vert_outlined)),

                ),
          ),
        ),
      ),
    );
  }
}
