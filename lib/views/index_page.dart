import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:plantory/views/community/community_page.dart';
import 'package:plantory/views/plant/plants_page.dart';
import 'package:plantory/views/setting/setting_page.dart';
import 'package:unicons/unicons.dart';
import '../data/plant.dart';
import '../utils/colors.dart';
import 'calendar/calendar_page.dart';
import 'home/home_page.dart';
import '../controller/bottom_nav_controller.dart';

List<Plant> plantList = [
  Plant(
    id: 0,
    image: null,
    pinned: true,
    name: "로꼬",
    type: "다육이",
    date: "2022-07-27",
    note: null,
    cycles:[
      {
        Cycles.id.name : 0,
        Cycles.type.name : "물",
        Cycles.cycle.name : "7",
        Cycles.startDate.name : "2022-07-27",
        Cycles.init.name : false,
      },
      {
        Cycles.id.name : 1,
        Cycles.type.name : "분갈이",
        Cycles.cycle.name : "30",
        Cycles.startDate.name : "2022-07-28",
        Cycles.init.name : false
      },
    ],
    timelines: List.empty(growable: true),
  ),
];


class IndexPage extends GetView<BottomNavController> {

  IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Obx(()  => Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffEEF1F1),
      body: IndexedStack(
        index: controller.pageIndex.value,
        children: [
          HomePage(plantList: plantList,),
          CalendarPage(plantList: plantList,),
          PlantsPage(plantList: plantList,),
          CommunityPage(),
          SettingPage(),
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
