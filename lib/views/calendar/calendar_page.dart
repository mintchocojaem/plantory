// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';
import 'calendar.dart';

class CalendarPage extends StatefulWidget{
  CalendarPage({Key? key}) : super(key: key);

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
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Calender",
          style: TextStyle(color: primaryColor),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              //image: DecorationImage(image: AssetImage("images/1.png"))
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: notificationIcon(context: context),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Calendar(),
        ),
      ),
    );
  }
}

plantCategory(String? imgPath) {
  return Column(
    children:  [
      CircleAvatar(
        radius: 36,
        backgroundColor: Colors.black,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Center(
            child: imgPath == null ? const Icon(
              UniconsLine.flower,
              size: 40,
              color: primaryColor,
            ) : Image.asset(
              imgPath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Text("Plant Name")
    ],
  );

}

calendedrLabel({String? label, Color? color}) {
  return Material(
    color: Color(0xffEEF1F1),
    shape: const StadiumBorder(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: color,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(label!,
              style: const TextStyle(
                color: Color(
                  0xff252624,
                ),
                fontWeight: FontWeight.w600,
              ))
        ],
      ),
    ),
  );
}
