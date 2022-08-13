// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plantory/views/calendar/timeline_add_page.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import 'calendar.dart';

class CalendarPage extends StatefulWidget{
  CalendarPage({Key? key, required this.person }) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CalendarPage();
  }

}

class _CalendarPage extends State<CalendarPage>{


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black54,),
        ),
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Calender",
          style: TextStyle(color: primaryColor),
        ),
        actions: [

        ],
    ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Calendar(person:  widget.person,),
      ),
      floatingActionButton: widget.person.plants!.isNotEmpty ? FloatingActionButton(
        onPressed: () {
          Get.to(() => TimelineAddPage(person : widget.person,),transition: Transition.downToUp)?.then((value) => setState((){}));
        },
        heroTag: null,
        child: Icon(Icons.add),backgroundColor: primaryColor,)
      : Container(),
    );
  }
}
