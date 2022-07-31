import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlantNotification {
  PlantNotification({required this.id, required this.title, required this.content});

  int id;
  String title;
  String content;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationDetails android;
  late IOSNotificationDetails ios;
  late NotificationDetails details;
  bool? result;

  init() async{

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final AndroidNotificationChannel channel;
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true,);

    android = AndroidNotificationDetails(channel.id, channel.name,
        channelDescription: channel.description ,
        importance: channel.importance, priority: Priority.high, playSound: true);

    ios = const IOSNotificationDetails();

    details = NotificationDetails(android: android, iOS: ios);

  }
  /*
  zonedSchedule() async{
    if ((!Platform.isAndroid && result != null && result!) || Platform.isAndroid) {

      tz.initializeTimeZones();
      String timeZone = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone));

      final storage = GetStorage();
      bool isNotification = storage.read('notification') ?? true;

      if(isNotification){
        await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            title,
            content,
            tz.TZDateTime.now(tz.local).add(Duration(days: duration)),
            detail,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime
        );
      }
    }
  }

   */

  show() async{
    if ((!Platform.isAndroid && result != null && result!) || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        content,
        details,
      );
    }
  }


}

