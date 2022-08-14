import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlantNotification {

  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;
  static late AndroidNotificationDetails android;
  static late IOSNotificationDetails ios;
  static late NotificationDetails details;
  bool? result;

  init() async{

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_stat_1');

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

  zonedMidnightSchedule(int id, String title, String content, int days) async{
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
            tz.TZDateTime.from(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()), tz.local).add(Duration(days: days)),
            //tz.TZDateTime.from(DateTime.now(), tz.local).add(Duration(seconds: 5)),
            details,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime
        );
      }
    }
  }

  show(int id, String title, String content) async{

    if ((!Platform.isAndroid && result != null && result!) || Platform.isAndroid) {
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        content,
        details,
      );
    }
  }

  cancel(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }


}

