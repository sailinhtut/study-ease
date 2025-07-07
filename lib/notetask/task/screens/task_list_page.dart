import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:notetask/notetask/task/components/group_task_tile.dart';
import 'package:notetask/notetask/task/components/task_tile.dart';
import 'package:notetask/notetask/task/screens/task_edit.dart';

import '../../../common/colors.dart';
import '../../../services/audio_services.dart';
import '../model/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  Set<int> cacheTasks = {};
  Set<int> selectedTasks = {};

  final offsetYNotifier = ValueNotifier<double>(300);

  bool isAllSelected = false;

  final aa = InkRipple.splashFactory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          appState.withBackground.value ? Colors.transparent : null,
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: tasks.listenable(),
        builder: (ctx, data, child) {
          if (data.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.listCheck,
                  color: Colors.grey,
                  size: 30,
                ),
                10.height,
                Text(
                  language.noTask,
                  style: secondaryTextStyle(),
                )
              ],
            ));
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(13).copyWith(bottom: 100),
            onReorder: (oldIndex, newIndex) {
              final oldKey = data.keys
                  .toList()[newIndex > oldIndex ? newIndex - 1 : newIndex];
              final oldTask = data.get(oldKey);
              final requesterKey = data.keys.toList()[oldIndex];
              final requesterTask = data.get(requesterKey);
              tasks.put(requesterKey, oldTask!);
              tasks.put(oldKey, requesterTask!);
            },
            itemCount: data.keys.length,
            itemBuilder: (ctx, index) {
              final key = data.keys.toList()[index];
              final currentBox = data.get(key);
              return
                  // Start
                  currentBox!.isGroupTask ?? false
                      ? GroupTile(
                          task: currentBox, taskKey: key, key: ValueKey(key))
                      : GestureDetector(
                          key: ValueKey(key),
                          onTap: () async {
                            currentBox.done = !currentBox.done;
                            data.put(key, currentBox);
                            final isGroupTile = currentBox.isGroupTask ?? false;
                            if (currentBox.done && !isGroupTile) {
                              await AudioService.instance.ding();
                            } else {
                              await AudioService.instance.unding();
                            }
                          },
                          child: TaskTile(
                            task: currentBox,
                            taskKey: key,
                          ),
                        );

              // end
            },
          );
        },
      ),
      floatingActionButton: Container(
        height: 200,
        width: 100,
        // color: Colors.amber,
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildAddingFloatingActionButton(context),
            20.height,
            _buildAddingGroupFloatingActionButton(context)
          ],
        ),
      ),
    );
  }

  /// Adding Task
  Widget _buildAddingFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => const AddTaskWidget());
        },
        elevation: appState.withBackground.value ? 0 : 8,
        shape: RoundedRectangleBorder(borderRadius: radius(15)),
        backgroundColor: appState.withBackground.value
            ? Colors.amber.withOpacity(0.3)
            : Theme.of(context).brightness == Brightness.dark
                ? context.cardColor
                : Colors.white,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(FontAwesomeIcons.checkDouble,
              key: UniqueKey(), color: context.primaryColor),
        ));
  }

  Widget _buildAddingGroupFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => const AddGroupWidget());
        },
        shape: RoundedRectangleBorder(borderRadius: radius(15)),
        elevation: appState.withBackground.value ? 0 : 8,
        backgroundColor: appState.withBackground.value
            ? Colors.amber.withOpacity(0.3)
            : Theme.of(context).brightness == Brightness.dark
                ? context.cardColor
                : Colors.white,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: Icon(FontAwesomeIcons.layerGroup,
              key: UniqueKey(), color: context.primaryColor),
        ));
  }
}

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({Key? key}) : super(key: key);

  @override
  State<AddTaskWidget> createState() => AddTaskWidgetState();
}

class AddTaskWidgetState extends State<AddTaskWidget> {
  final noteFormKey = GlobalKey<FormState>();
  final todoFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  Color selectedColor = Colors.blueGrey;

  InputDecoration getInputDecoration(String hintText, {String? helperText}) =>
      InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
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
                        attachNotes: [],
                        done: false,
                        isGroupTask: false);
                    tasks.add(task);
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

class AddGroupWidget extends StatefulWidget {
  const AddGroupWidget({Key? key, this.editGroup, this.editGroupKey})
      : super(key: key);

  final Task? editGroup;
  final int? editGroupKey;

  @override
  State<AddGroupWidget> createState() => AddGroupWidgetState();
}

class AddGroupWidgetState extends State<AddGroupWidget> {
  final todoGroupFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

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
  void initState() {
    super.initState();
    if (widget.editGroup != null) {
      nameController.text = widget.editGroup!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(7).copyWith(bottom: 50),
      decoration: BoxDecoration(
        color: isDarkMode ? context.cardColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Form(
        key: todoGroupFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.height,
              Text(
                  widget.editGroup != null
                      ? language.edit
                      : language.addingGroupTask,
                  style: boldTextStyle(
                      size: 15,
                      color: isDarkMode ? Colors.white : Colors.black)),
              25.height,
              TextFormField(
                controller: nameController,
                decoration: getInputDecoration(language.groupName),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return language.taskNameIsRequired;
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
              ),
              14.height,
              AppButton(
                width: double.maxFinite,
                height: 50,
                padding: const EdgeInsets.all(13),
                text: widget.editGroup != null ? language.edit : language.add,
                color: context.primaryColor,
                onTap: () {
                  if (todoGroupFormKey.currentState!.validate()) {
                    if (widget.editGroup != null &&
                        widget.editGroupKey != null) {
                      widget.editGroup!.name = nameController.text;
                      tasks.put(widget.editGroupKey!, widget.editGroup!);
                      finish(context);
                      return;
                    }
                    final task = Task(
                        name: nameController.text,
                        description: null,
                        taskColor: null,
                        done: false,
                        isGroupTask: true,
                        decendents: []);
                    tasks.add(task);
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
