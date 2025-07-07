import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/common/constants.dart';
import 'package:notetask/main.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher_string.dart';

class About extends StatelessWidget {
  About({super.key});

  final markdownData = '''
  **Study Ease** is simple note taking application for Android Devices.We mainly developed it more useful 
features, and original concept is derived from [Google Keep](https://play.google.com/store/apps/details?id=com.google.android.keep&hl=en_IN&gl=US). Study Ease is developed with structured 
multi-level task system to make you well managed a project. Study Ease also care students who learn
their lessons from mobile devices by enabling Floppy Style Keep Note [ Floppy Note ]. Hence, the students 
can easily take importance facts in Floopy Note instead of re-entering into Application again and again.
We are developing on more fantastic experiences to our users such as easy customized color, beautiful
background theme view, so on. As our team, we would like to ask you give us your bright beautiful
ideas or feedbacks that our services missed out. Have a great day ... my dear users

--- 

Help Center 

[Give Feed Back](mailto:sailinhtut76062@gmail.com?subject=Feedback Submit)

If you interest more products of our team,please check out 

[Visit Birghter Life](https://play.google.com/store/apps/dev?id=6495177881844118000)


> Version 2.0
All right reserved @ 2022
Created With ❤ by **Brighter Life** 




''';

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'smith@example.com',
    query: json.encode(<String, String>{
      'subject': 'Example Subject & Symbols are allowed!',
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appState.isDarkMode.value ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 30,
          ),
          onPressed: () {
            finish(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Study Ease", style: TextStyle(fontSize: 30)),
                Image.asset(
                  appIconOnly,
                  height: 80,
                  width: 80,
                )
              ],
            ),
            25.height,
            MarkdownBody(
                data: markdownData,
                softLineBreak: true,
                styleSheet: MarkdownStyleSheet(
                    horizontalRuleDecoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.2)),
                        color: Colors.transparent),
                    blockquoteAlign: WrapAlignment.spaceEvenly,
                    blockquoteDecoration: BoxDecoration(
                        color: appState.isDarkMode.value
                            ? Colors.white.withOpacity(0.1)
                            : const Color(0xffe5e5e5),
                        borderRadius: BorderRadius.circular(14))),
                onTapLink: (text, href, title) => launchUrlString(href!,
                    mode: LaunchMode.externalApplication)),
            100.height
          ],
        ),
      ),
    );
  }
}
