import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nb_utils/nb_utils.dart';

class FAQ extends StatelessWidget {
  FAQ({super.key});

  final floppyAnswer = """- [x] Click **Floppy Note** again


> It is because System does not response at once
              """;

  final groupInnerTask = """
Sorry dear user,it cannot be changed.
""";

  final photoError = """
Sorry for unconfortness my user,it is because of selecting high
resolution image when ***Internal Memory*** is lower.

Please kindly choose
resonable quality image and Thank You ❤
""";

  final overlayCrash = """
Sorry for unconfortness my user,it is heavy issue.

> **Overlay Window** in Android Operating System is presenting apart of Service
from parent application on device screen runtime.Overlayed UI communicates
with main application by emitting signal between each other.It received signal and 
process data from main application,and vice versa.

*Issue : After enormous amount of signals emitting between *Floppy Note* and *Study Ease*,
it become noticed by Android Service Manager and sometimes it break down permitted Overlay
window to prevent system harm.That is why **Floppy Note Disappered***

## Do not worry
---
However Floopy is forced to shut down, we still recover your data stored in that and also 
you can open it again.It will purely work again when you reactivate *Floppy Note* in main application.

- [x] Go back to application
- [x] Open Drawer and activate *Floppy Note*

***Tips : Always click 'Save' button ever after your write down your information to prevent 
data losing.***

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        actions: [
          IconButton(
              onPressed: () {
                toast("Thank You ❤");
              },
              icon: Icon(Icons.vpn_key))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10).copyWith(bottom: 100),
        children: [
          const Question(
              question: "How to partially select text in note page ?",
              markdown: "- [x] Start dragging from bottom"),
          Question(
              question: "Floppy Note donesn't come out ?",
              markdown: floppyAnswer),
          Question(
              question:
                  "Can I change group inner task's attached note button with desired note?",
              markdown: groupInnerTask),
          Question(
              question: "Application crash after choose attached photo ",
              markdown: photoError),
          Question(
              question: "Floppy Note Disapper Sometimes",
              markdown: overlayCrash),
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  const Question({super.key, required this.question, required this.markdown});

  final String question;
  final String markdown;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(question),
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: const EdgeInsets.all(10),
          children: [
            10.height,
            MarkdownBody(
                data: markdown,
                checkboxBuilder: (value) => value
                    ? const Icon(
                        Icons.check_box,
                        size: 15,
                        color: Colors.green,
                      )
                    : const Icon(
                        Icons.check_box_outline_blank_outlined,
                        size: 15,
                      ),
                styleSheet: MarkdownStyleSheet(
                    horizontalRuleDecoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.2)),
                        color: Colors.transparent),
                    blockquoteDecoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.amber.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8)))),
            20.height
          ],
        ),
      ),
    );
  }
}
