import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


class BottomNavController extends GetxController {


  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    switch(value) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
        _changePage(value);
        break;
    };
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}

