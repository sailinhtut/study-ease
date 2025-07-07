import 'package:android_window/android_window.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'common/themes.dart';
import 'states/app_controller.dart';
// import 'package:android_window/main.dart' as android_window;

class FloatApp extends StatelessWidget {
  const FloatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: AndroidWindow(child: FloatingFrame()));
  }
}

class FloatingFrame extends StatefulWidget {
  const FloatingFrame({super.key});

  @override
  State<FloatingFrame> createState() => _FloatingFrameState();
}

class _FloatingFrameState extends State<FloatingFrame> {
  bool isCollapsed = true;
  int currentHeight = 1000;

  final controller = TextEditingController();
  final node = FocusNode();

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    AndroidWindow.setHandler((name, data) async {
      switch (name) {
        case "giveMeCopy":
          controller.text += "\n\n ${data as String}";
          break;
      }
    });
    return isCollapsed ? _buildCircleFloat() : _buildFloatApp();
  }

  Widget _buildCircleFloat() {
    return FloatingActionButton(
        elevation: 0,
        shape: const CircleBorder(side: BorderSide(color: Colors.black26)),
        onPressed: () async {
          controller.text =
              getStringAsync("floppyText", defaultValue: "Noting Saved");
          AndroidWindow.resize(double.maxFinite.toInt(), currentHeight);
          setState(() {
            isCollapsed = false;
          });
        },
        child: const Icon(Icons.edit));
  }

  @override
  void initState() {
    super.initState();
    print("output : Init State is created");
    controller.text = getStringAsync("floppyText");
  }

  Widget _buildFloatApp() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 2,
            actions: [
              IconButton(
                  onPressed: () async {
                    AndroidWindow.post("giveMeCopy");
                  },
                  icon: const Icon(
                    FontAwesomeIcons.paste,
                    size: 20,
                  )),
              PopupMenuButton<int>(
                  icon: const Icon(Icons.swap_vert),
                  onSelected: (value) {
                    node.unfocus();
                    switch (value) {
                      case 500:
                        AndroidWindow.resize(double.maxFinite.toInt(), 500);
                        break;
                      case 600:
                        AndroidWindow.resize(double.maxFinite.toInt(), 600);
                        break;
                      case 700:
                        AndroidWindow.resize(double.maxFinite.toInt(), 700);
                        break;
                      case 800:
                        AndroidWindow.resize(double.maxFinite.toInt(), 800);
                        break;
                      case 900:
                        AndroidWindow.resize(double.maxFinite.toInt(), 900);
                        break;
                      case 1000:
                        AndroidWindow.resize(double.maxFinite.toInt(), 1000);
                        break;
                      case 1100:
                        AndroidWindow.resize(double.maxFinite.toInt(), 1100);
                        break;
                      case 1200:
                        AndroidWindow.resize(double.maxFinite.toInt(), 1200);
                        break;
                      case 1300:
                        AndroidWindow.resize(double.maxFinite.toInt(), 1300);
                        break;
                    }
                    setState(() {
                      currentHeight = value;
                    });
                  },
                  itemBuilder: (ctx) => const [
                        PopupMenuItem(
                          value: 500,
                          child: Text("x500"),
                        ),
                        PopupMenuItem(
                          value: 600,
                          child: Text("x600"),
                        ),
                        PopupMenuItem(
                          value: 700,
                          child: Text("x700"),
                        ),
                        PopupMenuItem(
                          value: 800,
                          child: Text("x800"),
                        ),
                        PopupMenuItem(
                          value: 900,
                          child: Text("x900"),
                        ),
                        PopupMenuItem(
                          value: 1000,
                          child: Text("x1000"),
                        ),
                        PopupMenuItem(
                          value: 1100,
                          child: Text("x1100"),
                        ),
                        PopupMenuItem(
                          value: 1200,
                          child: Text("x1200"),
                        ),
                        PopupMenuItem(
                          value: 1300,
                          child: Text("x1300"),
                        ),
                      ]),
              const Expanded(child: SizedBox()),
              TextButton(
                  onPressed: () async {
                    await setValue("floppyText", controller.text);
                    AndroidWindow.post("floppyData", controller.text);
                    AndroidWindow.resize(130, 130);
                    setState(() {
                      isCollapsed = true;
                    });
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Color.fromARGB(255, 206, 155, 0)),
                  )),
              IconButton(
                  onPressed: () async {
                    await setValue("floppyText", controller.text);
                    AndroidWindow.post("floppyData", controller.text);
                    AndroidWindow.post("deactivated");
                    AndroidWindow.close();
                  },
                  icon: const Icon(Icons.close)),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                onCanceled: () => node.unfocus(),
                onSelected: (value) => node.unfocus(),
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    onTap: () {
                      node.unfocus();
                      AndroidWindow.launchApp();
                      AndroidWindow.resize(130, 130);
                      setState(() {
                        isCollapsed = true;
                      });
                    },
                    child: const Text("Study Ease"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      node.unfocus();
                      AndroidWindow.post("copyThis", controller.text);
                    },
                    child: const Text("Copy All"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      node.unfocus();
                      final start = controller.selection.start;
                      final end = controller.selection.end;
                      final selectedText =
                          controller.text.substring(start, end);
                      AndroidWindow.post("copyThis", selectedText);
                    },
                    child: const Text("Copy Selected"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      node.unfocus();
                      controller.text = "";
                      AndroidWindow.post("floppyData", "");
                    },
                    child: const Text("Clear"),
                  ),
                ],
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(5).copyWith(bottom: 300),
            controller: scrollController,
            child: TextFormField(
              maxLines: null,
              controller: controller,
              focusNode: node,
              onTap: () {
                // scrollController.animToBottom();
              },
              decoration: const InputDecoration(
                  hintText: "Note ...", border: InputBorder.none),
            ),
          )),
    );
  }
}
