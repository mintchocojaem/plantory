// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:unicons/unicons.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class CalenderView extends StatelessWidget {
  const CalenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Text("Calender"),
                ],
              ),
              notificationIcon(context: context)
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: 120,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => plantCategory(),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 25,
                    ),
                itemCount: 10),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
                color: profilePageBackgroundColor,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.all(10),
            child: SfCalendar(
              todayHighlightColor: const Color(0xff588168),
              cellBorderColor: profilePageBackgroundColor,
              backgroundColor: profilePageBackgroundColor,
              // showCurrentTimeIndicator: true,
              showDatePickerButton: true,

              viewHeaderStyle: const ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                color: Color(0xff7A807A),
                fontWeight: FontWeight.w700,
              )),
              view: CalendarView.month,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              calendedrLabel(label: "Cleaning", color: const Color(0xff588168)),
              const SizedBox(
                width: 15,
              ),
              calendedrLabel(
                  label: "harvest", color: profilePageBackgroundColor),
            ],
          ),
          Container(
            height: 30,
          )
        ],
      ),
    );
  }


}


plantCategory() {
  return Column(
    children: const [
      CircleAvatar(
        radius: 36,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          child: Center(
            child: Icon(UniconsLine.flower),
          ),
          backgroundColor: splashScreenTextColor,
          radius: 34,
        ),
      ),
      Text("Plant Name")
    ],
  );
}

calendedrLabel({String? label, Color? color}) {
  return Material(
    color: const Color(0xffE5E6E0),
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
