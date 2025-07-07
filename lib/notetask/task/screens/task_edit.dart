import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';

import '../../../common/colors.dart';
import '../../../services/notification_services.dart';
import '../../../testing/test_screen.dart';
import '../../note/model/note.dart';
import '../../note/screens/favourite_notes.dart';
import '../../note/screens/note_write_page.dart';
import '../../note/screens/note_write_temp.dart';
import '../model/task.dart';

class TaskEdit extends StatefulWidget {
  const TaskEdit({super.key, required this.task, required this.taskKey});
  final int taskKey;
  final Task task;

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final todoFormKey = GlobalKey<FormState>();

  Color selectedColor = Colors.blueGrey;

  bool isAdvancedTask = false;

  DateTime? scheduledTime;
  String formatTimeString = "Set";

  Map<int, Note> attachedNotesList = {};

  void formatTime(DateTime time) {
    formatTimeString = DateFormat('h:m a').format(time);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.task.name;
    descriptionController.text = widget.task.description ?? "No Description";
    selectedColor = Color(widget.task.taskColor ?? Colors.blueGrey.value);

    if (widget.task.remainder != null) {
      formatTime(DateTime.fromMillisecondsSinceEpoch(widget.task.remainder!));
    }

    if (widget.task.attachNotes != null) {
      loadAttachedNotes();
    }
  }

  Future<void> loadAttachedNotes() async {
    for (var key in widget.task.attachNotes!) {
      final note = attachedNotes.get(key);
      if (note == null) {
        return;
      }
      attachedNotesList.putIfAbsent(key, () => note);
    }
  }

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
    return Scaffold(
        appBar: AppBar(title: Text(language.editTask)),
        // backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(14).copyWith(bottom: 100),
            child: Form(
              key: todoFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  14.height,
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
                  20.height,

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
                                                color: Colors.white24,
                                                width: 1)),
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: selectedColor.value == e.value
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
                    text: language.edit,
                    color: context.primaryColor,
                    onTap: () {
                      if (todoFormKey.currentState!.validate()) {
                        widget.task.name = nameController.text;
                        widget.task.description = descriptionController.text;
                        widget.task.taskColor = selectedColor.value;
                        tasks.put(widget.taskKey, widget.task);
                        toast(language.successfullyEdited);
                        finish(context);
                      }
                    },
                  ),
                  20.height,

                  // Advacned Task
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isAdvancedTask = !isAdvancedTask;
                        });
                      },
                      child: Row(
                        children: [
                          Text(language.advancedOption,
                              style: primaryTextStyle(
                                  size: 13,
                                  color: isAdvancedTask
                                      ? Colors.blueGrey
                                      : Colors.blue)),
                          10.width,
                          AnimatedRotation(
                              turns: isAdvancedTask ? 1.5 : 2,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(FontAwesomeIcons.angleDown,
                                  size: 20,
                                  color: isAdvancedTask
                                      ? Colors.blueGrey
                                      : Colors.blue))
                        ],
                      )),
                  AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: isAdvancedTask
                          ? Container(
                              // color: Colors.amber,
                              child: Column(children: [
                              ListTile(
                                title: Text(language.remainder),
                                trailing: TextButton(
                                  child: Text(formatTimeString),
                                  onPressed: () async {
                                    final datetime =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            widget.task.remainder ??
                                                DateTime.now()
                                                    .millisecondsSinceEpoch);

                                    final timeOfDay = TimeOfDay(
                                        hour: datetime.hour,
                                        minute: datetime.hour);

                                    final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: timeOfDay);

                                    if (pickedTime != null) {
                                      final calculateDateTime = DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          pickedTime.hour,
                                          pickedTime.minute);

                                      widget.task.remainder = calculateDateTime
                                          .millisecondsSinceEpoch;

                                      tasks.put(widget.taskKey, widget.task);

                                      formatTime(calculateDateTime);
                                      try {
                                        await NotificationServices.instance
                                            .createScheduleNotification(
                                                language.heyBuddy,
                                                "${widget.task.name}\n${widget.task.description}",
                                                calculateDateTime
                                                    .millisecondsSinceEpoch);
                                        toast(language.setRemainder);
                                      } catch (e) {
                                        final nextDay = calculateDateTime
                                            .add(const Duration(days: 1))
                                            .millisecondsSinceEpoch;
                                        await NotificationServices.instance
                                            .createScheduleNotification(
                                                language.heyBuddy,
                                                "${widget.task.name}\n${widget.task.description}",
                                                nextDay);
                                        toast(language.notiMoveToNextDay);
                                      }
                                      setState(() {});

                                      // Set Notification Here

                                    }
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(language.attachedNotes),
                                trailing: Builder(
                                  builder: (ctx) => IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      showBottomSheet(
                                          context: ctx,
                                          backgroundColor: Colors.transparent,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(20))),
                                          builder: (ctx) =>
                                              AddAttachedNoteWidget(
                                                  onCreated: (note) async {
                                                final key = await attachedNotes
                                                    .add(note);
                                                widget.task.attachNotes ??= [];
                                                widget.task.attachNotes!
                                                    .add(key);
                                                tasks.put(widget.taskKey,
                                                    widget.task);
                                                setState(() {});
                                                await loadAttachedNotes();
                                                // ignore: use_build_context_synchronously
                                                finish(context);
                                              }));
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 150,
                                  child: GridView.count(
                                    crossAxisCount: 1,
                                    scrollDirection: Axis.horizontal,
                                    children: attachedNotesList
                                        .map((key, value) => MapEntry(
                                            key,
                                            GestureDetector(
                                              onTap: () {
                                                NoteWrite(
                                                  note: value,
                                                  noteKey: key,
                                                  isAttachedNote: true,
                                                ).launch(context);
                                              },
                                              child: NoteCard(note: value),
                                            )))
                                        .values
                                        .toList(),
                                  ))
                            ]))
                          : const SizedBox()),
                  20.height,
                ],
              ),
            )));
  }
}

class AddAttachedNoteWidget extends StatefulWidget {
  const AddAttachedNoteWidget({Key? key, required this.onCreated})
      : super(key: key);

  final Function(Note createdNote) onCreated;

  @override
  State<AddAttachedNoteWidget> createState() => AddAttachedNoteWidgetState();
}

class AddAttachedNoteWidgetState extends State<AddAttachedNoteWidget> {
  final noteFormKey = GlobalKey<FormState>();
  final todoFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final bodyController = TextEditingController();
  Color selectedColor = Colors.white;

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(7).copyWith(bottom: 50),
        decoration: BoxDecoration(
          color: isDarkMode ? context.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black12),
        ),
        child: Form(
          key: noteFormKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.height,
              Text(language.addingNote,
                  style: boldTextStyle(
                      size: 15,
                      color: isDarkMode ? Colors.white : Colors.black)),
              25.height,
              TextFormField(
                controller: nameController,
                decoration: getInputDecoration(language.caption),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return language.captionIsRequired;
                  }
                  return null;
                },
                style: const TextStyle(color: Colors.black),
              ),
              14.height,
              TextFormField(
                controller: bodyController,
                decoration: getInputDecoration("Keep Your Valuable Note Here ",
                    helperText: language.canEditLater),
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
              ),
              15.height,
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
                text: language.edit,
                color: context.primaryColor,
                onTap: () {
                  if (noteFormKey.currentState!.validate()) {
                    final note = Note(
                        caption: nameController.text,
                        body: bodyController.text,
                        noteColor: selectedColor.value,
                        archieve: false,
                        favourite: false,
                        created: DateTime.now());
                    widget.onCreated(note);
                  }
                },
              ),
              20.height,
            ],
          )),
        ));
  }
}
