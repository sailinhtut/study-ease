import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notetask/services/notification_services.dart';

class CloudMessageServices {
  static CloudMessageServices? _instance;
  CloudMessageServices._private();

  static CloudMessageServices get instance =>
      _instance ??= CloudMessageServices._private();

  Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    await messaging.subscribeToTopic("notetask_main");

    FirebaseMessaging.onMessage.listen(_firebaseCloudMessageForegroundCallback);
  }

  // Foreground Service
  Future<void> _firebaseCloudMessageForegroundCallback(
      RemoteMessage message) async {
    NotificationServices.instance.createNotification(
        message.notification!.title!, message.notification!.body!);
  }

  // Background Service
  Future<void> _firebaseCloudMessageBackgroundCallback(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
