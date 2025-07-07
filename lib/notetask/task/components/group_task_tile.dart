import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/notetask/note/screens/note_write_page.dart';
import 'package:notetask/notetask/note/screens/note_write_temp.dart';
import 'package:notetask/notetask/task/model/task.dart';
import 'package:notetask/notetask/task/screens/sub_task_edit.dart';
import 'package:notetask/notetask/task/screens/task_list_page.dart';

import '../../../common/colors.dart';
import '../../../main.dart';
import '../../../services/audio_services.dart';

class GroupTile extends StatefulWidget {
  const GroupTile({super.key, required this.task, required this.taskKey});

  final Task task;
  final int taskKey;

  @override
  State<GroupTile> createState() => GroupTileState();
}

class GroupTileState extends State<GroupTile> {
  bool selectMode = false;
  bool expanded = false;

  Set<int> selectedTasks = {};

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;

    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.transparent,
            onPressed: (ctx) {
              showBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (ctx) => AddGroupWidget(
                      editGroupKey: widget.taskKey, editGroup: widget.task));
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
                        content: Text(
                            "Are you sure to delete ${widget.task.name} ?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (widget.task.decendents != null) {
                                  for (var subTask in widget.task.decendents!) {
                                    for (var key in subTask.attachNotes!) {
                                      attachedNotes.delete(key);
                                    }
                                  }
                                }
                                tasks.delete(widget.taskKey);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Color(widget.task.taskColor ??
                                        context.primaryColor.value)),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel",
                                  style: TextStyle(
                                      color: Color(widget.task.taskColor ??
                                          context.primaryColor.value)))),
                        ],
                      ));
            },
            foregroundColor: Colors.grey,
            icon: Icons.delete_outline_rounded,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: appState.withBackground.value
            ? Colors.black.withOpacity(0.6)
            : null,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              onExpansionChanged: (value) => setState(() {
                    expanded = value;
                  }),
              title: Text(
                widget.task.name,
                style: TextStyle(
                    decoration: widget.task.decendents!
                            .any((element) => element.done == false)
                        ? TextDecoration.none
                        : TextDecoration.lineThrough),
              ),
              trailing: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 800),
                  child: expanded
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [buildCreateButton()],
                        )
                      : Text(
                          'Group',
                          style: secondaryTextStyle(size: 11),
                        )),
              collapsedIconColor: isDarkMode ? Colors.black : Colors.white,
              collapsedTextColor: isDarkMode ? Colors.black : Colors.white,
              textColor: isDarkMode ? Colors.black : Colors.white,
              iconColor: isDarkMode ? Colors.black : Colors.white,
              childrenPadding: const EdgeInsets.all(0),
              children: widget.task.decendents != null ||
                      widget.task.decendents!.isNotEmpty
                  ? [
                      if (selectMode)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Select Tasks  : ${selectedTasks.length}",
                                style: secondaryTextStyle(size: 10)),
                            10.width
                          ],
                        ),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10)),
                        child: Container(
                            decoration: BoxDecoration(
                              color: appState.withBackground.value
                                  ? null
                                  : !isDarkMode
                                      ? Color(0xff323639)
                                      : Color(0xffe5e5e5),
                              border: const Border(
                                  top: BorderSide(color: Colors.black12)),
                            ),
                            child: Column(children: [
                              ...widget.task.decendents!
                                  .map((e) => buildSubTaskTile(
                                      widget.task.decendents!.indexOf(e), e))
                                  .toList()
                            ])),
                      )
                    ]
                  : [
                      ListTile(
                        title: Text(
                          "No Tasks In ${widget.task.name}",
                        ),
                      )
                    ]),
        ),
      ),
    );
  }

  Widget buildSubTaskTile(int index, Task task) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: task.attachNotes != null ? 0.4 : 0.3,
        motion: const DrawerMotion(),
        children: [
          if (task.attachNotes != null)
            SlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (ctx) {
                final firstAttachedNote =
                    attachedNotes.get(task.attachNotes!.first);
                NoteWrite(
                        note: firstAttachedNote!,
                        noteKey: task.attachNotes!.first,
                        isAttachedNote: true)
                    .launch(context,
                        pageRouteAnimation: PageRouteAnimation.Scale);
              },
              foregroundColor:
                  Color(task.taskColor ?? Colors.grey.value).withOpacity(0.7),
              icon: Icons.insert_drive_file_outlined,
            ),
          SlidableAction(
            backgroundColor: Colors.transparent,
            onPressed: (ctx) {
              SubTaskEdit(
                      parentTask: widget.task,
                      parentTaskKey: widget.taskKey,
                      childTask: task,
                      childTaskIndex: index)
                  .launch(context);
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
                        content: Text("Are you sure to delete ${task.name} ?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                if (task.attachNotes != null) {
                                  for (var key in task.attachNotes!) {
                                    attachedNotes.delete(key);
                                  }
                                }
                                widget.task.decendents!.removeAt(index);
                                tasks.put(widget.taskKey, widget.task);
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
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          widget.task.decendents![index].done =
              !widget.task.decendents![index].done;

          if (widget.task.decendents![index].done) {
            await AudioService.instance.ding();
          } else {
            await AudioService.instance.unding();
          }
          tasks.put(widget.taskKey, widget.task);
        },
        child: Card(
          margin: const EdgeInsets.only(
            left: 30,
            bottom: 5,
            top: 5,
            right: 5,
          ),
          color: appState.withBackground.value
              ? Colors.grey.withOpacity(0.5)
              : null,
          child: ListTile(
            leading: selectMode
                ? CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 15,
                    child: selectedTasks.contains(index)
                        ? Icon(Icons.check_rounded)
                        : SizedBox())
                : Checkbox(
                    activeColor: Color(task.taskColor ?? Colors.green.value),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onChanged: (value) {},
                    value: task.done,
                  ),
            title: Text(task.name),
            trailing: task.done
                ? const Text(
                    "Completed",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget buildCreateButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (ctx) =>
                AddSubTaskWidget(task: widget.task, taskKey: widget.taskKey));
      },
    );
  }

  Widget buildEditButton() {
    return IconButton(
      icon: const Icon(Icons.create),
      onPressed: () {
        setState(() {
          selectMode = !selectMode;
        });
      },
    );
  }
}

// class CurvedLine extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final brush = Paint();
//     brush.style = PaintingStyle.stroke;
//     brush.color = Colors.grey;
//     brush.strokeCap = StrokeCap.round;
//     brush.strokeWidth = 2;
//     final pencil = Path();

//     canvas.drawPath(pencil, brush);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

class AddSubTaskWidget extends StatefulWidget {
  const AddSubTaskWidget({Key? key, required this.task, required this.taskKey})
      : super(key: key);

  final Task task;
  final int taskKey;

  @override
  State<AddSubTaskWidget> createState() => AddSubTaskWidgetState();
}

class AddSubTaskWidgetState extends State<AddSubTaskWidget> {
  final noteFormKey = GlobalKey<FormState>();
  final todoFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  Color selectedColor = Colors.blueGrey;

  InputDecoration getInputDecoration(String hintText, {String? helperText}) =>
      InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.black12)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: Colors.black12)),
          contentPadding: const EdgeInsets.all(5),
          filled: true,
          fillColor: const Color(0xffe5e5e5),
          counterText: helperText);

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      // duration: const Duration(milliseconds: 700),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(7).copyWith(bottom: 50),
      decoration: BoxDecoration(
        color: isDarkMode ? context.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Form(
        key: todoFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            key: UniqueKey(),
            children: [
              30.height,
              Text(language.addingTask,
                  style: boldTextStyle(
                      size: 15,
                      color: isDarkMode ? Colors.white : Colors.black)),
              25.height,
              TextFormField(
                controller: nameController,
                decoration: getInputDecoration(language.taskName),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return language.taskNameIsRequired;
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
              ),
              14.height,
              TextFormField(
                controller: descriptionController,
                decoration: getInputDecoration(
                  language.taskDescription,
                ),
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
              ),
              10.height,
              Text(language.chooseColor),
              SizedBox(
                height: 60,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: appState.availableColors
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColor = e;
                                    });
                                  },
                                  child: Card(
                                    color: e,
                                    elevation: 0,
                                    shape: const CircleBorder(
                                        side: BorderSide(
                                            color: Colors.white24, width: 1)),
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: selectedColor == e
                                          ? Icon(Icons.check,
                                              color: e == Colors.white
                                                  ? Colors.black
                                                  : Colors.white)
                                          : null,
                                    ),
                                  ),
                                ))
                            .toList())),
              ),
              13.height,
              AppButton(
                width: double.maxFinite,
                height: 50,
                padding: const EdgeInsets.all(13),
                text: language.add,
                color: context.primaryColor,
                onTap: () {
                  if (todoFormKey.currentState!.validate()) {
                    final task = Task(
                        name: nameController.text,
                        description: descriptionController.text,
                        taskColor: selectedColor.value,
                        done: false,
                        isGroupTask: false);
                    if (widget.task.decendents != null) {
                      widget.task.decendents!.add(task);
                      tasks.put(widget.taskKey, widget.task);
                    }
                    finish(context);
                  }
                },
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }
}
