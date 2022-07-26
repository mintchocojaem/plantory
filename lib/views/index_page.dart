import 'package:flutter/material.dart';
import 'package:plantory/views/plant/plants_page.dart';
import 'package:plantory/views/profile_page.dart';
import 'package:unicons/unicons.dart';
import '../utils/colors.dart';
import 'calendar/calendar_page.dart';
import 'home/home_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPage createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> {
  ontap(index) => setState(() => currentIndex = index);

  int currentIndex = 0;
  final List<BottomNavigationBarItem> navBarItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          UniconsLine.home,
        ),
        label: "Home"),
    const BottomNavigationBarItem(
        icon: Icon(UniconsLine.calender), label: "Calender"),
    const BottomNavigationBarItem(
        icon: Icon(
          UniconsLine.flower,
        ),
        label: "Plants"),
    const BottomNavigationBarItem(
        icon: Icon(
          UniconsLine.user,
        ),
        label: "Profile"),
  ];
  final List<Widget> views = [
     HomePage(),
     CalendarPage(),
     PlantsPage(plantList: plantList,),
     ProfilePage(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      body: IndexedStack(
        index: currentIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: ontap,
          currentIndex: currentIndex,
          backgroundColor: Color(0xffEEF1F1),
          elevation: 1,
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          items: navBarItems),
    );
  }
}
