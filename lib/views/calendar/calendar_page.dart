// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plantory/views/calendar/timeline_add_page.dart';
import 'package:unicons/unicons.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';
import '../../data/plant.dart';
import '../plant/plant_add_page.dart';
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
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Calender",
          style: TextStyle(color: primaryColor),
        ),
        actions: [

        ],
    ),
      body: widget.person.plants!.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Calendar(person:  widget.person,),
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(UniconsLine.flower),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Plantory에 처음 오신 것을 환영합니다."),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("이용자님의 첫 식물을 추가해보세요!"),
            ),
            MaterialButton(
              color: Color(0xffC9D9CF),
              onPressed: (){
                Get.to(() => PlantAddPage(person: widget.person,));
              },
              child: Text("식물 추가"),
            )
          ],
        ),
      ),
      floatingActionButton: widget.person.plants!.isNotEmpty ? FloatingActionButton(
        onPressed: () {
          Get.to(() => TimelineAddPage(person : widget.person,))?.then((value) => setState((){}));
        },
        heroTag: null,
        child: Icon(Icons.add),backgroundColor: primaryColor,) : Container(),
    );
  }
}
