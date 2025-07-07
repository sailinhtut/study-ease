import 'dart:convert';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:notetask/main.dart';

import '../language/languages.dart';

class AppController extends GetxController {
  final isDarkMode = false.obs;
  final textScale = 1.1.obs; // max : 1.3
  final languageCode = "my".obs;
  final backgroundImage = "".obs;
  final withBackground = false.obs;

  List<Color> userColors = <Color>[].obs;

  List<Color> get availableColors => [...featureColors, ...userColors];

  @override
  void onInit() {
    super.onInit();
    loadUserColors();

    if (backgroundImage.isEmpty) {
      withBackground(false);
    }
  }

  void setDarkMode(bool darkModeFlag) async {
    isDarkMode(darkModeFlag);
    // changeNavigationBarState(isDarkMode.value);
    await setValue("isDarkMode", darkModeFlag);
  }

  void setTextScale(double scale) async {
    textScale(scale);
    await setValue("textScale", scale);
  }

  void setLanguageCode(String code) async {
    languageCode(code);
    switch (code) {
      case "my":
        language = MyanmarLanguage();
        break;
      case "en":
        language = EnglishLanguage();
    }
    await setValue("language", code);
  }

  void setBackgroundImage(String assetPath) {
    if (assetPath.isEmpty) {
      withBackground(false);
      backgroundImage("");
      setValue("backgroundImagePath", assetPath);
    } else {
      withBackground(true);
      backgroundImage(assetPath);
      setDarkMode(true);
      setValue("backgroundImagePath", assetPath);
    }
  }

  void addColor(Color value) {
    if (userColors.contains(value)) {
      toast("This color is already picked");
      return;
    }
    userColors.add(value);
    saveUserColors();
  }

  void removeColor(Color value) {
    if (featureColors.contains(value)) {
      toast("Sorry .. Original Color Cannot Be Removed");
    } else {
      userColors.remove(value);
      saveUserColors();
    }
  }

  void loadUserColors() {
    final dataString = getStringAsync("userColors", defaultValue: "[]");
    List<int> data = (json.decode(dataString) as List<dynamic>).cast<int>();
    userColors = data.map((e) => Color(e)).toList();
  }

  void saveUserColors() {
    final colorCodeList = userColors.map((e) => e.value).toList();
    setValue("userColors", json.encode(colorCodeList));
  }
}

List<Color> featureColors = const [
  Color.fromARGB(255, 187, 194, 197),
  Color.fromARGB(255, 235, 119, 110),
  Color.fromARGB(255, 65, 163, 244),
  Color.fromARGB(255, 242, 198, 68),
  Color.fromARGB(255, 131, 224, 134),
  Color.fromARGB(255, 198, 113, 212),
  Color.fromARGB(255, 218, 101, 140),
  Color.fromARGB(255, 227, 167, 76),
  Color.fromARGB(255, 209, 149, 127),
];
