// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';
import '../../data/plant.dart';
import 'calendar.dart';

class CalendarPage extends StatefulWidget{
  CalendarPage({Key? key, required this.plantList}) : super(key: key);

  final List<Plant> plantList;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CalendarPage();
  }

}

class _CalendarPage extends State<CalendarPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Calender",
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: notificationIcon(context: context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Calendar(plantList: widget.plantList,),
      ),
    );
  }
}
