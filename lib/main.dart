

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/float_app.dart';
import 'package:notetask/testing/main_parellel.dart';
import 'package:notetask/notetask/task/model/task.dart';
import 'package:notetask/services/admob_services.dart';
import 'package:notetask/services/audio_services.dart';
import 'package:notetask/services/notification_services.dart';
import 'package:notetask/states/app_controller.dart';
import 'package:notetask/states/float_controller.dart';
import 'app.dart';
import 'language/languages.dart';
import 'notetask/note/model/note.dart';
import 'services/cloud_messaging_services.dart';

final appState = Get.find<AppController>();
BaseLanguage language = EnglishLanguage();
late Box<Task> tasks;
late Box<Note> notes;
late Box<Note> attachedNotes;
int adCount = 0;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

@pragma('vm:entry-point')
void androidWindow() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp( FloatApp());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // All Initializations for application running
  await prepareConfigs();

  fullScreen();

  // runApp(const App());
  runApp(App());
}

void fullScreen() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.bottom]);
}

Future<void> prepareConfigs() async {
  // Firebase Initialize
  await Firebase.initializeApp();
  CloudMessageServices.instance.init();
  NotificationServices.instance.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Thrid Party
  await initialize();

  // Database
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(NoteAdapter());
  tasks = await Hive.openBox<Task>("tasks");
  notes = await Hive.openBox<Note>("notes");
  attachedNotes = await Hive.openBox<Note>("attachedNotes");

  // Advertise
  await AdmobServices.instance.init();

  // Audio Service
  await AudioService.instance.init();

  // State Controller Dependencies Injection
  Get.put(AppController());

  // Configure UI Settings
  final isDarkMode = getBoolAsync("isDarkMode", defaultValue: false);
  final textScale = getDoubleAsync("textScale", defaultValue: 1.1);
  final languageCode = getStringAsync("language", defaultValue: "en");
  final backgroundImagePath =
      getStringAsync("backgroundImagePath", defaultValue: "");
  appState.setDarkMode(isDarkMode);
  appState.setTextScale(textScale);
  appState.setLanguageCode(languageCode);
  appState.setBackgroundImage(backgroundImagePath);
}
