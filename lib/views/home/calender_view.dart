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
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: notificationIcon(context: context),
              ),
            ),
            decoration: BoxDecoration(
              //image: DecorationImage(image: AssetImage("images/1.png"))
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12
              ),
              child: Center(child: Text("뭐 넣을지 고민중", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),)),
            ),
          ),
          Divider(),
          /*Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: 120,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>  plantCategory('images/plant${index+1}.jpeg'),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 25,
                    ),
                itemCount: 4),
          ),

           */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              child: SfCalendar(
                todayHighlightColor: Colors.orangeAccent,
                //showCurrentTimeIndicator: true,
                showDatePickerButton: false,
                view: CalendarView.week,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              calendedrLabel(label: "Cleaning", color: Colors.orangeAccent),
              const SizedBox(
                width: 15,
              ),
              calendedrLabel(
                  label: "Watering", color: Colors.blue),
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
