import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../services/notification_services.dart';
import '../model/note.dart';

class NoteWriteTemp extends StatefulWidget {
  const NoteWriteTemp({super.key, required this.noteKey, required this.note});

  final Note note;
  final int noteKey;

  @override
  State<NoteWriteTemp> createState() => _NoteWriteTempState();
}

class _NoteWriteTempState extends State<NoteWriteTemp> {
  bool isFavourite = false;
  bool isArchieve = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFavourite = widget.note.favourite ?? false;
    isArchieve = widget.note.archieve ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Colors.grey,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                  widget.note.favourite = isFavourite;
                  notes.put(widget.noteKey, widget.note);
                  toast(isFavourite
                      ? "Add to favourites"
                      : "Remove from favourites");
                });
              },
              icon: Icon(isFavourite ? Icons.favorite : Icons.favorite_outline),
            ),
            IconButton(
                onPressed: () async {
                  NotificationServices.instance.createNotification(
                      "Note Task Application", "Never Should Give Up");
                },
                icon: const Icon(Icons.notifications_active)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    isArchieve = !isArchieve;
                    widget.note.archieve = isArchieve;
                    notes.put(widget.noteKey, widget.note);
                    toast(isArchieve
                        ? "Note is archieved"
                        : "Note is unarchieved");
                  });
                },
                icon: Icon(isArchieve ? Icons.archive : Icons.unarchive))
          ],
        ),
        backgroundColor: Color(widget.note.noteColor!).withAlpha(200),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(widget.note.caption, textScaleFactor: 2.0),
            10.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.warning_rounded, color: Colors.amber),
                SizedBox(width: 10),
                Text("Note Write Page is being maintained")
              ],
            ),
          ],
        )));
  }
}
