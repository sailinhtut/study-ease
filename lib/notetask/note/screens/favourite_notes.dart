import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notetask/notetask/note/model/note.dart';
import 'package:notetask/notetask/note/screens/note_write_page.dart';
import 'package:notetask/notetask/note/screens/note_write_temp.dart';

class FavouriteNotes extends StatelessWidget {
  const FavouriteNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            Text(language.favourites),
            10.width,
            const Icon(Icons.favorite_rounded)
          ],
        )),
        body: ValueListenableBuilder<Box<Note>>(
          valueListenable: notes.listenable(),
          builder: (context, value, child) {
            final filterdList =
                value.values.where((element) => element.favourite!);

            final filteredKeys = filterdList.map((element) {
              return value.keyAt(value.values.toList().indexOf(element));
            }).toList();

            if (filteredKeys.isEmpty) {
              return Center(child: Text(language.noFavourites));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: filteredKeys.length,
              itemBuilder: (ctx, index) {
                final currentKey = filteredKeys.toList()[index];

                Note note = value.get(currentKey)!;
                final isFavourite = note.favourite;

                return isFavourite!
                    ? GestureDetector(
                        onTap: () {
                          NoteWrite(
                            noteKey: currentKey,
                            note: note,
                            isAttachedNote: false,
                          
                          ).launch(context,
                              pageRouteAnimation: PageRouteAnimation.Scale);
                        },
                        child: NoteCard(note: note))
                    : const SizedBox();
              },
            );
          },
        ));
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, super.key});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Color(note.noteColor!),
        shape: RoundedRectangleBorder(
            borderRadius: radius(13),
            side:
                BorderSide(color: Color(note.noteColor ?? Colors.white.value))),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Text(
                note.caption,
                style: const TextStyle(
                    fontSize: 17, height: 1.2, color: Colors.black38),
              ),
              10.height,
              Flexible(
                child: Text(note.body,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: const TextStyle(
                        fontSize: 10, height: 1.6, color: Colors.black38)),
              )
            ],
          ),
        ));
  }
}
