import 'package:flutter/material.dart';
import 'package:plantory/views/home/profile_view.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import 'calender_view.dart';
import 'home_view.dart';
import 'my_plant_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    const HomeView(),
    const CalenderView(),
    const MyPlantView(),
    const ProfileView(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: views,
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: ontap,
          currentIndex: currentIndex,
          backgroundColor: homeBackgroundColor,
          elevation: 1,
          selectedItemColor: primaryColor,
          type: BottomNavigationBarType.fixed,
          items: navBarItems),
    );
  }
}
