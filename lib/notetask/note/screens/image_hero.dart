import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:notetask/notetask/note/model/note.dart';

class HeroImage extends StatefulWidget {
  const HeroImage(
      {Key? key,
      required this.noteKey,
      required this.note,
      required this.onDeleted})
      : super(key: key);

  final int noteKey;
  final Note note;
  final Function(int noteKey, Note note) onDeleted;

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure to delete this photo ?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      finish(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      widget.note.image = null;
                                      notes.put(widget.noteKey, widget.note);
                                      finish(context);
                                      widget.onDeleted(
                                          widget.noteKey, widget.note);
                                      setState(() {});
                                    },
                                    child: Text("Delete"))
                              ]));
                },
                icon: Icon(Icons.delete))
          ],
        ),
        // backgroundColor: Color(0xfff1f2f3),
        body: Center(
            child: widget.note.image == null
                ? const Text("No Image Data")
                : Image.memory(base64Decode(widget.note.image!))));
  }
}
