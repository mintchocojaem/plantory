import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:plantory/binding/binding.dart';
import 'package:plantory/views/auth/auth_page.dart';
import 'package:plantory/views/auth/lang/ko.dart';
import 'package:plantory/views/index_page.dart';
import 'package:plantory/views/notification/notification.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  await initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(localizationsDelegates: [

      // Delegates below take care of built-in flutter widgets
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,

      // This delegate is required to provide the labels that are not overridden by LabelOverrides
      FlutterFireUIRuLocalizationsDelegate(),
      FlutterFireUILocalizations.delegate,
    ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: //SplashScreen(),
              IndexPage(),
              // AuthPage(),
        initialBinding: InitBinding(),
    );
  }

}

initNotification() async{

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      PlantNotification plantNotification = PlantNotification(
          id: notification.hashCode,
          title: notification.title ?? "",
          content: notification.body ?? ""
      );
      await plantNotification.init();
      await plantNotification.show();
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //print(message);
  });

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print('Handling a background message ${message.messageId}');
}
