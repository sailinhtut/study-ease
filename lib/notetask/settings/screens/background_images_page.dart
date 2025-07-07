import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/main.dart';
import 'package:notetask/states/app_controller.dart';

class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => ThemeSelectorState();
}

class ThemeSelectorState extends State<ThemeSelector> {
  String selectedImagePath = appState.backgroundImage.value;

  final backgroundImageList = [
    "",
    "assets/back_one.jpg",
    "assets/back_two.jpg",
    "assets/back_three.jpg",
    "assets/back_four.jpg",
    "assets/back_five.jpg",
    "assets/back_six.jpg",
    "assets/back_seven.jpg",
    "assets/back_eight.jpg",
    "assets/back_nine.jpg",
    "assets/back_ten.jpg",
    "assets/back_eleven.jpg",
    "assets/back_twelve.jpg",
    "assets/back_thirteen.jpg",
    "assets/back_fourteen.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Text(language.themes),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GetX<AppController>(
        builder: (controller) => Stack(
          fit: StackFit.expand,
          children: [
            if (controller.withBackground.value)
              Image.asset(controller.backgroundImage.value, fit: BoxFit.fill),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: SafeArea(
                child: SizedBox(
                  height: 170,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: backgroundImageList
                            .map((e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedImagePath = e;
                                    });
                                    appState.setBackgroundImage(e);
                                  },
                                  child: Card(
                                      shape: dialogShape(10),
                                      elevation: 7,
                                      shadowColor: Colors.lightBlue,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            e,
                                            width: 100,
                                            fit: BoxFit.fill,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    SizedBox.fromSize(
                                              size: Size.fromWidth(100),
                                              child: Center(
                                                child:
                                                    Icon(Icons.do_not_disturb),
                                              ),
                                            ),
                                          ))),
                                ))
                            .toList()),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
