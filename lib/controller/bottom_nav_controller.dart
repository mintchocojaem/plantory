import 'package:get/get.dart';


class BottomNavController extends GetxController {

  RxInt pageIndex = 0.obs;

  void changeBottomNav(int value) {
    switch(value) {
      case 0:
      case 1:
      case 2:
      case 3:
        _changePage(value);
        break;
    };
  }

  void _changePage(int value) {
    pageIndex(value);
  }

}
