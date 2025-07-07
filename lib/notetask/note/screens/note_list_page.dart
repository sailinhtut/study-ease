import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/float_app.dart';
import 'package:notetask/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notetask/notetask/note/screens/note_write_page.dart';
import '../model/note.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage(
      {Key? key, required this.isInEditMode, required this.onEditStatusChanged})
      : super(key: key);

  final bool isInEditMode;
  final Function(bool isEdit) onEditStatusChanged;

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  Set<int> cacheNotes = {};
  Set<int> selectedNotes = {};
  List<int> filteredNotes = [];

  final offsetYNotifier = ValueNotifier<double>(300);

  bool isAllSelected = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Theme.of(context).brightness == Brightness.dark ? true : false;

    return Scaffold(
      backgroundColor:
          appState.withBackground.value ? Colors.transparent : null,
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9),
          child: ValueListenableBuilder<Box<Note>>(
            valueListenable: notes.listenable(),
            builder: (ctx, data, child) {
              // final keys = data.keys.cast<int>().toList();

              final filterdList =
                  data.values.where((element) => !element.archieve!);

              final filteredKeys = filterdList.map((element) {
                return data.keyAt(data.values.toList().indexOf(element)) as int;
              }).toList();

              filteredNotes = filteredKeys;

              if (data.isEmpty) {
                return Center(
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon( 
                      FontAwesomeIcons.noteSticky,
                      color: Colors.grey,
                      size: 30,
                    ),
                    10.height,
                    Text(
                      language.noKeepNote,
                      style: secondaryTextStyle(),
                    )
                  ],
                ));
              }
              return GridView.builder(
                  padding: const EdgeInsets.only(top: 30, bottom: 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      crossAxisCount: 2),
                  itemCount: filteredKeys.length,
                  itemBuilder: (ctx, index) {
                    final key = filteredKeys.toList()[index];
                    final currentNote = data.get(key);
                    final isSelected = selectedNotes.contains(key);

                    return OpenContainer(
                      transitionDuration: const Duration(milliseconds: 500),
                      openBuilder: (context, action) => NoteWrite(
                        noteKey: key,
                        note: currentNote!,
                        isAttachedNote: false,
                      ),
                      closedColor: Colors.transparent,
                      closedElevation: 0,
                      openColor: Colors.transparent,
                      openElevation: 0,
                      closedBuilder: (ctx, action) => GestureDetector(
                        onTap: () {
                          if (widget.isInEditMode) {
                            selectedNotes.contains(key)
                                ? selectedNotes.remove(key)
                                : selectedNotes.add(key);
                            if (selectedNotes.isEmpty) {
                              widget.onEditStatusChanged(false);
                            }
                            setState(() {});
                          } else {
                            action();
                          }
                        },
                        onLongPress: () {
                          setState(() {
                            widget.onEditStatusChanged(true);

                            selectedNotes.add(key);
                          });
                        },
                        child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.horizontal,
                                onDismissed: (direction) {
                                  currentNote!.archieve = true;
                                  notes.put(key, currentNote);
                                },
                                child: Card(
                                    elevation: 2,
                                    color: Color(currentNote!.noteColor!)
                                        .withOpacity(0.9),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: radius(13),
                                        side: BorderSide(
                                            color: widget.isInEditMode &&
                                                    isSelected
                                                ? Colors.black45
                                                : Colors.transparent)),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          10.height,
                                          Text(
                                            currentNote.caption,
                                            style: TextStyle(
                                                fontSize: 17,
                                                height: 1.2,
                                                color: isDarkMode
                                                    ? Colors.black54
                                                    : Colors.black),
                                          ),
                                          10.height,
                                          Flexible(
                                            child: Text(currentNote.body,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    height: 1.6,
                                                    color: isDarkMode
                                                        ? Colors.black54
                                                        : Colors.black54)),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              if (widget.isInEditMode && isSelected)
                                const Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Card(
                                    shape: CircleBorder(),
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Icon(Icons.check),
                                    ),
                                  ),
                                )
                            ]),
                      ),
                    );
                  });
            },
          ),
        ),
        if (widget.isInEditMode)
          ValueListenableBuilder<double>(
            valueListenable: offsetYNotifier,
            builder: (ctx, value, child) => Positioned(
              bottom: value,
              right: 0,
              child: AnimatedSlide(
                duration: const Duration(seconds: 1),
                offset: Offset(widget.isInEditMode ? 0 : 1, 0),
                child: GestureDetector(
                  key: UniqueKey(),
                  onPanUpdate: (details) {
                    offsetYNotifier.value -= details.delta.dy;
                    print("output : from bottom ${offsetYNotifier.value}");
                    // setState(() {});
                  },
                  child: Card(
                      margin: const EdgeInsets.only(right: 0),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(13))),
                      child: SizedBox(
                        child: Column(
                          children: [
                            5.height,
                            CircleAvatar(
                              child: Text(
                                selectedNotes.length.toString(),
                                style: TextStyle(color: Colors.amber.shade800),
                              ),
                            ),
                            10.height,
                            Checkbox(
                                value: isAllSelected,
                                onChanged: (value) {
                                  setState(() {
                                    isAllSelected = !isAllSelected;
                                    if (isAllSelected) {
                                      cacheNotes = selectedNotes;
                                      selectedNotes.addAll(filteredNotes);
                                    } else {
                                      selectedNotes = cacheNotes;
                                      cacheNotes.clear();
                                    }
                                  });
                                }),
                            IconButton(
                                onPressed: () async {
                                  await notes.deleteAll(selectedNotes);
                                  widget.onEditStatusChanged(false);
                                  selectedNotes.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete)),
                            IconButton(
                                onPressed: () async {
                                  widget.onEditStatusChanged(false);
                                  selectedNotes.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.clear))
                          ],
                        ),
                      )),
                ),
              ),
            ),
          )
      ]),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Adding Task
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        elevation: appState.withBackground.value ? 0 : 5,
        onPressed: () {
          showBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              builder: (ctx) => const AddNoteWidget());
        },
        shape: RoundedRectangleBorder(borderRadius: radius(15)),
        backgroundColor: appState.withBackground.value
            ? Colors.amber.withOpacity(0.3)
            : Theme.of(context).brightness == Brightness.dark
                ? context.cardColor
                : context.primaryColor,
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              FontAwesomeIcons.penFancy,
              color: Theme.of(context).brightness == Brightness.dark
                  ? context.primaryColor
                  : Colors.black,
            )));
  }
}

class AddNoteWidget extends StatefulWidget {
  const AddNoteWidget({Key? key}) : super(key: key);

  @override
  State<AddNoteWidget> createState() => AddNoteWidgetState();
}

class AddNoteWidgetState extends State<AddNoteWidget> {
  final noteFormKey = GlobalKey<FormState>();
  final todoFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final bodyController = TextEditingController();
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
              10.height,
              TextFormField(
                controller: nameController,
                decoration: getInputDecoration(language.caption),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return language.captionIsRequired;
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black),
              ),
              14.height,
              TextFormField(
                controller: bodyController,
                decoration: getInputDecoration(language.taskDescription,
                    helperText: language.canEditLater),
                maxLines: 5,
                style: const TextStyle(color: Colors.black),
              ),
              14.height,
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
                  if (noteFormKey.currentState!.validate()) {
                    final note = Note(
                        caption: nameController.text,
                        body: bodyController.text,
                        noteColor: selectedColor.value,
                        archieve: false,
                        favourite: false,
                        created: DateTime.now());
                    notes.add(note);
                    finish(context);
                  }
                },
              ),
              20.height,
            ],
          )),
        ));
  }
}
