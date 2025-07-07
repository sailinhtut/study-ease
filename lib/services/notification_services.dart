import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:notetask/common/colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  NotificationServices._private();

  static NotificationServices? _instance;

  static NotificationServices get instance =>
      _instance ??= NotificationServices._private();

  final _notiPlugIn = FlutterLocalNotificationsPlugin();

  // Setting Up Plug In
  Future<void> init(
      {Function(NotificationResponse? payload)? onNotiTapped}) async {
    const forAndroid = AndroidInitializationSettings("apps_logo");
    const darwin = DarwinInitializationSettings();

    const initializationSettings =
        InitializationSettings(android: forAndroid, iOS: darwin);

    tz.initializeTimeZones();

    await _notiPlugIn.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onNotiTapped,
        onDidReceiveNotificationResponse: onNotiTapped);
    print("output : Notification Plug In is initialized");
  }

  // Getting Notification Details
  NotificationDetails getNotiDetails() {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'notetask999', 'notetaskchannel',
        groupKey: 'notetaskgroup',
        channelDescription: 'Notification For NoteTask',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        color: Colors.white,
        enableVibration: true,
        largeIcon: const DrawableResourceAndroidBitmap("app_icon_only"));

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future<void> createNotification(String title, String body) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '', 'ug_vpn',
        groupKey: 'ug_vpn_notification_group',
        channelDescription: 'Notification For VPN',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        color: Colors.white,
        enableVibration: true,
        icon: "app_icon_only",
        largeIcon: DrawableResourceAndroidBitmap("app_icon_only"),
        actions: [
          AndroidNotificationAction("gotit", "I got it",
              titleColor: primaryLight)
        ],
        styleInformation: BigTextStyleInformation(body));

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notiPlugIn.show(1232, title, body, platformChannelSpecifics,
        payload: "I was too hurted");
  }

  Future<void> createScheduleNotification(
      String title, String body, int timestamp,
      {Uint8List? image}) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '', 'ug_vpn',
        groupKey: 'ug_vpn_notification_group',
        channelDescription: 'Notification For VPN',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        color: Colors.white,
        enableVibration: true,
        icon: "app_icon_only",
        largeIcon: image != null ? ByteArrayAndroidBitmap(image) : null,
        styleInformation: BigTextStyleInformation(body));

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notiPlugIn.zonedSchedule(
        Random().nextInt(1000),
        title,
        body,
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, timestamp),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  Future<void> deleteAllScheduledNotifications() async {
    _notiPlugIn.cancelAll();
  }
}
