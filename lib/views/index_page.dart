import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:plantory/views/community/community_page.dart';
import 'package:plantory/views/plant/plants_page.dart';
import 'package:plantory/views/setting/setting_page.dart';
import 'package:unicons/unicons.dart';
import '../data/person.dart';
import '../data/plant.dart';
import '../utils/colors.dart';
import 'calendar/calendar_page.dart';
import 'home/home_page.dart';
import '../controller/bottom_nav_controller.dart';


class IndexPage extends GetView<BottomNavController> {

  IndexPage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  Widget build(BuildContext context) {

    return Obx(()  => Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffEEF1F1),
      body: IndexedStack(
        index: controller.pageIndex.value,
        children: [
          HomePage(person: person),
          CalendarPage(person: person),
          PlantsPage(person: person,),
          CommunityPage(),
          SettingPage(person: person),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value){
            controller.changeBottomNav(value);
          },
          currentIndex: controller.pageIndex.value,
          backgroundColor: Color(0xffEEF1F1),
          elevation: 1,
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  UniconsLine.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(UniconsLine.calender), label: "Calender"),
            BottomNavigationBarItem(
                icon: Icon(
                  UniconsLine.flower,
                ),
                label: "Plants"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.comment,
                ),
                label: "Community"),
            BottomNavigationBarItem(
                icon: Icon(
                  UniconsLine.setting,
                ),
                label: "Settings"),
          ]
      )
    ));
  }
}
