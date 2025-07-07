import 'dart:convert';
import 'package:android_window/main.dart' as android_window;

import 'dart:io';
import 'package:android_window/android_window.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:notetask/services/admob_services.dart';
import 'package:notetask/services/file_services.dart';
import 'package:notetask/services/notification_services.dart';
import 'package:notetask/states/float_controller.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import '../model/note.dart';
import 'image_hero.dart';

class NoteWrite extends StatefulWidget {
  const NoteWrite({
    super.key,
    required this.note,
    required this.noteKey,
    required this.isAttachedNote,
  });

  final Note note;
  final int noteKey;

  // Task Attach Requesting For Edit Access
  final bool isAttachedNote;

  @override
  State<NoteWrite> createState() => NoteWriteState();
}

class NoteWriteState extends State<NoteWrite> with WidgetsBindingObserver {
  final titleNode = FocusNode();
  final bodyNode = FocusNode();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  InputDecoration getDecoration({String? hintText}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black38),
        border: InputBorder.none);
  }

  bool isFavourite = false;
  bool isArchieve = false;

  Color selectedColor = Colors.blueGrey;
  Color textColor = Colors.black;

  bool withBackground = false;
  String? backgroundImagePath;

  List<String> stack = [];
  final indexNotifier = ValueNotifier<int>(0);
  bool isSaved = false;

  bool isFloatMode = false;

  InterstitialAd? interAdvertise;

  final scrollController = ScrollController();

  String gzipBase64Encode(String value) {
    final utf8Encode = utf8.encode(value);
    final gzipEncode = gzip.encode(utf8Encode);
    final base64 = base64Encode(gzipEncode);
    return base64;
  }

  String gzipBase64Decode(String base64) {
    final base64D = base64Decode(base64);
    final gzipDecode = gzip.decode(base64D);
    final utf8Decode = utf8.decode(gzipDecode);
    return utf8Decode;
  }

  void stackAdd() {
    final encodedData = gzipBase64Encode(bodyController.text);

    // Check Dublicate Stack
    final lastValue = stack.isEmpty ? "" : gzipBase64Decode(stack.last);
    if (lastValue == bodyController.text) {
      return;
    }

    // Add Stack
    stack.add(encodedData);
    indexNotifier.value = stack.length - 1;
  }

  Future<void> saveNote() async {
    widget.note.caption = titleController.text;
    widget.note.body = bodyController.text;
    widget.note.noteColor = selectedColor.value;
    widget.note.archieve = isArchieve;
    widget.note.favourite = isFavourite;

    if (backgroundImagePath != null) {
      widget.note.backgroundImage = backgroundImagePath;
    }

    widget.isAttachedNote
        ? attachedNotes.put(widget.noteKey, widget.note)
        : notes.put(widget.noteKey, widget.note);
  }

  void loadNote() {
    // action
    titleController.text = widget.note.caption;
    bodyController.text = widget.note.body;
    isFavourite = widget.note.archieve ?? false;
    isArchieve = widget.note.favourite ?? false;
    selectedColor = Color(widget.note.noteColor ?? Colors.blueGrey.value);
    textColor = Color(widget.note.textColor ?? Colors.black.value);

    if (widget.note.backgroundImage != null) {
      withBackground = true;
      backgroundImagePath = widget.note.backgroundImage;
    }
  }

  // loading advertise
  void loadAdvertise() {
    if (AdmobServices.adsCounter == 1) {
      AdmobServices.instance.loadInterstistial(onSuccessfullLoaded: (ads) {
        interAdvertise = ads;
      });
    }
  }

  // decide should show advertise
  Future<void> showAdvertise() async {
    if (AdmobServices.adsCounter == 1) {
      AdmobServices.adsCounter = 0;
      await AdmobServices.instance.showInterstistial(interAdvertise);
    } else {
      AdmobServices.adsCounter++;
      print('output : Count ${AdmobServices.adsCounter}');

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote();
    loadAdvertise();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    saveNote();
    WidgetsBinding.instance.removeObserver(this);
    showAdvertise();
  }

  @override
  void didChangeMetrics() {
    if (WidgetsBinding.instance.window.viewInsets.bottom <= 0) {
      if (!isSaved) {
        saveNote();
        stackAdd();
        isSaved = true;
      }
    } else {
      isSaved = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.resumed) {
      if (!isSaved) {
        saveNote();
        isSaved = true;
      }
    }
  }

  void clearAllFocus() {
    bodyNode.unfocus();
    titleNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,

      backgroundColor: selectedColor,
      appBar: buildAppBar(context),
      body: WillPopScope(
        onWillPop: () async {
          saveNote();
          if (bodyNode.hasFocus || titleNode.hasFocus) {
            clearAllFocus();
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: withBackground
                  ? BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(backgroundImagePath!),
                          fit: BoxFit.fill))
                  : null,
              padding: const EdgeInsets.only(top: 80),
              // child:
              // NestedScrollView(
              //   controller: scrollController,
              //   headerSliverBuilder: (ctx, isInnerScrolling) => [buildAppBar()],
              child: SingleChildScrollView(
                // physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(10).copyWith(bottom: 400),
                controller: scrollController,
                child: Column(
                  children: [
                    if (widget.note.image != null)
                      ClipRRect(
                        borderRadius: radius(10),
                        child: Image.memory(base64Decode(widget.note.image!))
                            .onTap(() {
                          HeroImage(
                                  note: widget.note,
                                  noteKey: widget.noteKey,
                                  onDeleted: (key, note) {
                                    widget.note.image = note.image;
                                    setState(() {});
                                  })
                              .launch(context,
                                  pageRouteAnimation: PageRouteAnimation.Fade);
                        }),
                      ),
                    TextFormField(
                      focusNode: titleNode,
                      controller: titleController,
                      maxLines: null,
                      decoration: getDecoration(hintText: "Caption"),
                      style: TextStyle(fontSize: 22, color: textColor),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      focusNode: bodyNode,
                      controller: bodyController,
                      maxLines: null,
                      onTap: () {
                        // scrollController.animToBottom();
                      },
                      decoration: getDecoration(hintText: "Keep Note ... "),
                      style: TextStyle(color: textColor),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: (value) {
                        final lastValueFromCurrentCursor = bodyController.text
                            .substring(
                                0, bodyController.selection.extentOffset);
                        if (lastValueFromCurrentCursor.endsWith(" ") ||
                            lastValueFromCurrentCursor.endsWith("\n") ||
                            lastValueFromCurrentCursor.endsWith(".")) {
                          // value compressing
                          stackAdd();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0, left: 0, right: 0, child: buildBottomBar(context))
          ],
        ),
      ),
      // bottomNavigationBar: buildBottomBar(context)
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color(widget.note.noteColor ?? Colors.grey.value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(FontAwesomeIcons.paste),
                onPressed: () async {
                  final lastPosition = bodyController.selection.extent.offset;
                  final firstText =
                      bodyController.text.substring(0, lastPosition);
                  final lastText = bodyController.text
                      .substring(lastPosition, bodyController.text.length);
                  final pasteText = await FlutterClipboard.paste();
                  final operated = "$firstText$pasteText$lastText";
                  bodyController.text = operated;
                },
                color: textColor),
            const Expanded(
              child: SizedBox(),
            ),
            IgnorePointer(
              ignoring: indexNotifier.value <= 0,
              child: ValueListenableBuilder(
                valueListenable: indexNotifier,
                builder: (ctx, index, child) => IconButton(
                  onPressed: index == 0
                      ? null
                      : () {
                          indexNotifier.value--;

                          bodyController.text =
                              gzipBase64Decode(stack[indexNotifier.value]);
                          bodyNode.unfocus();
                        },
                  icon: const Icon(Icons.undo),
                  color: textColor,
                ),
              ),
            ),
            IgnorePointer(
              ignoring: indexNotifier.value >= stack.length,
              child: ValueListenableBuilder(
                valueListenable: indexNotifier,
                builder: (ctx, index, child) => IconButton(
                  onPressed: index == stack.length - 1
                      ? null
                      : () {
                          indexNotifier.value++;
                          bodyController.text =
                              gzipBase64Decode(stack[indexNotifier.value]);
                          bodyNode.unfocus();
                        },
                  icon: const Icon(Icons.redo),
                  color: textColor,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  showBottomMenu(context);
                },
                icon: Icon(Icons.more_vert, color: textColor))
          ],
        ),
      ),
    );
  }

  void showPalette(BuildContext context) {
    Color select = selectedColor;
    showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (ctx, setSt) => AlertDialog(
                title: const Text("Palette"),
                shape: dialogShape(14),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(
                    //     height: 120,
                    //     width: double.maxFinite,
                    //     child: SingleChildScrollView(
                    //       scrollDirection: Axis.horizontal,
                    //       physics: const BouncingScrollPhysics(),
                    //       child: Row(
                    //           children: backgroundImageList
                    //               .map((e) => GestureDetector(
                    //                     onTap: () {
                    //                       setState(() {
                    //                         backgroundImagePath = e;
                    //                         withBackground = true;
                    //                         saveNote();
                    //                       });
                    //                     },
                    //                     child: Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           horizontal: 8.0, vertical: 4),
                    //                       child: ClipRRect(
                    //                           borderRadius: radius(8),
                    //                           child: Image.asset(e)),
                    //                     ),
                    //                   ))
                    //               .toList()),
                    //     ))

                    SizedBox(
                      height: 35,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: appState.availableColors
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          setSt(() {
                                            select = e;
                                          });
                                          setState(() {
                                            selectedColor = select;
                                          });
                                          widget.note.noteColor = select.value;
                                          widget.isAttachedNote
                                              ? attachedNotes.put(
                                                  widget.noteKey, widget.note)
                                              : notes.put(
                                                  widget.noteKey, widget.note);
                                        },
                                        child: Card(
                                          color: e,
                                          elevation: 0,
                                          shape: const CircleBorder(
                                              side: BorderSide(
                                                  color: Colors.white24,
                                                  width: 2)),
                                          child: SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: select == e
                                                ? const Icon(Icons.check,
                                                    color: Colors.black)
                                                : null,
                                          ),
                                        ),
                                      ))
                                  .toList())),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        finish(context);
                      },
                      child: const Text("Close"))
                ],
              ),
            ));
  }

  void showAlarm(BuildContext context) {
    String formatTimeString = "Set";
    void formatTime(DateTime time) {
      formatTimeString = DateFormat('h:m a').format(time);
    }

    DateTime dueTime = widget.note.notificationTime ?? DateTime.now();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    InputDecoration getDecoration({String? hintText}) {
      return InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(5));
    }

    formatTime(dueTime);

    showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (ctx, setSt) => AlertDialog(
                title: Text(language.setAlarm),
                shape: dialogShape(14),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(language.dueTime),
                          trailing: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: context.primaryColor),
                                shape: const StadiumBorder()),
                            child: Text(formatTimeString),
                            onPressed: () async {
                              final datetime =
                                  DateTime.fromMillisecondsSinceEpoch(widget
                                          .note
                                          .notificationTime
                                          ?.millisecondsSinceEpoch ??
                                      DateTime.now().millisecondsSinceEpoch);

                              final timeOfDay = TimeOfDay(
                                  hour: datetime.hour, minute: datetime.hour);

                              final pickedTime = await showTimePicker(
                                  context: context, initialTime: timeOfDay);

                              if (pickedTime != null) {
                                final calculateDateTime = DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    pickedTime.hour,
                                    pickedTime.minute);

                                widget.note.notificationTime =
                                    calculateDateTime;
                                widget.isAttachedNote
                                    ? attachedNotes.put(
                                        widget.noteKey, widget.note)
                                    : notes.put(widget.noteKey, widget.note);

                                formatTime(calculateDateTime);
                                dueTime = calculateDateTime;
                                setSt(() {});
                              }
                            },
                          ),
                        ),
                        20.height,
                        TextFormField(
                          decoration:
                              getDecoration(hintText: language.notiTitle),
                          controller: titleController,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return language.notiTitleIsRequired;
                            }
                            return null;
                          },
                        ),
                        14.height,
                        TextFormField(
                          decoration:
                              getDecoration(hintText: language.notiBody),
                          controller: bodyController,
                          maxLines: 4,
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return language.notiBodyIsRequried;
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        finish(context);
                      },
                      child: Text(language.close,
                          style: TextStyle(color: Colors.grey))),
                  TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            await NotificationServices.instance
                                .createScheduleNotification(
                                    titleController.text,
                                    bodyController.text,
                                    dueTime.millisecondsSinceEpoch,
                                    image: widget.note.image != null
                                        ? base64Decode(widget.note.image!)
                                        : null);
                            toast(language.setRemainder);
                          } catch (e) {
                            final nextDay = dueTime
                                .add(const Duration(days: 1))
                                .millisecondsSinceEpoch;
                            await NotificationServices.instance
                                .createScheduleNotification(
                                    titleController.text,
                                    bodyController.text,
                                    nextDay,
                                    image: widget.note.image != null
                                        ? base64Decode(widget.note.image!)
                                        : null);
                            toast(language.notiMoveToNextDay);
                          } finally {
                            finish(context);
                          }
                        }
                      },
                      child: const Text("Set")),
                ],
              ),
            ));
  }

  void showBottomMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (btx) => SizedBox(
              height: 240,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(language.addImage),
                  onTap: () async {
                    clearAllFocus();
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      final bytes = await File(picked.path).readAsBytes();
                      final generatedPath =
                          await createTempFile(bytes, basename(picked.path));

                      final base64bytes = base64Encode(bytes);
                      widget.note.image = base64bytes;
                      widget.note.shareImagePath = generatedPath;
                      widget.isAttachedNote
                          ? attachedNotes.put(widget.noteKey, widget.note)
                          : notes.put(widget.noteKey, widget.note);

                      setState(() {});
                    }
                    finish(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notification_add),
                  title: Text(language.notification),
                  onTap: () {
                    finish(context);
                    clearAllFocus();
                    showAlarm(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_color_text),
                  title: Text(language.textBrigthness),
                  onTap: () {
                    setState(() {
                      textColor = textColor.value == Colors.black.value
                          ? const Color(0xffe5e5e5)
                          : Colors.black;
                    });
                    widget.note.textColor = textColor.value;
                    widget.isAttachedNote
                        ? attachedNotes.put(widget.noteKey, widget.note)
                        : notes.put(widget.noteKey, widget.note);
                    finish(context);
                  },
                )
              ]),
            ));
  }

  AppBar buildAppBar(BuildContext context) {
    final iconColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        actions: [
          IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () {
                clearAllFocus();
                showPalette(context);
              },
              color: textColor),
          Builder(builder: (context) {
            return PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              padding: const EdgeInsets.all(5),
              shape: dialogShape(10),
              elevation: 15,
              onSelected: (value) {
                clearAllFocus();
                switch (value) {
                  case 0:
                    isFavourite = !isFavourite;
                    widget.note.favourite = isFavourite;
                    widget.isAttachedNote
                        ? attachedNotes.put(widget.noteKey, widget.note)
                        : notes.put(widget.noteKey, widget.note);

                    toast(isFavourite
                        ? "Add to favourite"
                        : "Remove from favourite");
                    break;
                  case 1:
                    clearAllFocus();
                    isArchieve = !isArchieve;
                    widget.note.archieve = isArchieve;
                    widget.isAttachedNote
                        ? attachedNotes.put(widget.noteKey, widget.note)
                        : notes.put(widget.noteKey, widget.note);

                    // toast(isArchieve ? language.archieve : language.unArchieve);
                    break;
                  // case 2:
                  //   toast('Note Locker is available on premium');
                  //   break;
                  case 3:
                    shareDecideAndAction(context);
                    break;
                  default:
                    toast("Default");
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 0,
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: Center(
                      child: Row(
                    children: [
                      Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_outline,
                        color: iconColor,
                      ),
                      10.width,
                      Text(language.favourite),
                    ],
                  )),
                ),
                PopupMenuItem(
                  value: 1,
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(isArchieve ? Icons.unarchive : Icons.archive,
                          color: iconColor),
                      10.width,
                      Text(
                          isArchieve ? language.unArchieve : language.archieve),
                    ],
                  ),
                ),
                // PopupMenuItem(
                //   value: 2,
                //   padding: const EdgeInsets.only(left: 20),
                //   height: 40,
                //   child: Center(
                //       child: Row(
                //     children: [
                //       Icon(Icons.lock_open, color: iconColor),
                //       10.width,
                //       const Text("As Private"),
                //     ],
                //   )),
                // ),
                PopupMenuItem(
                  value: 3,
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  onTap: () {
                    bodyNode.unfocus();
                  },
                  child: Center(
                      child: Row(
                    children: [
                      Icon(
                        Icons.share,
                        color: iconColor,
                      ),
                      10.width,
                      Text(language.share),
                    ],
                  )),
                ),
              ],
            );
          })
        ]);
  }

  void shareDecideAndAction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (btx) => SizedBox(
              height: 170,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text(language.sharePhoto),
                  onTap: () {
                    Share.shareXFiles([XFile(widget.note.shareImagePath!)],
                        subject:
                            "${titleController.text}\n\n${bodyController.text}");
                    finish(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_drive_file_rounded),
                  title: Text(language.shareText),
                  onTap: () {
                    Share.share(
                        "${widget.note.caption}\n\n${widget.note.body}");
                    finish(context);
                  },
                )
              ]),
            ));
  }
}
