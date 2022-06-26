// ignore_for_file: prefer_const_constructors

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: notificationIcon(context: context),
              ),
            ),
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/1.png"))),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: DatePicker(
              DateTime.now(),
              monthTextStyle: TextStyle(),
              initialSelectedDate: DateTime.now(),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            // height: 250,
            height: MediaQuery.of(context).size.height * 0.30,
            width: double.infinity,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => plantCard(
                    context: context,
                    color: index % 2 == 0 ? primaryColor : Color(0xffF1CBB6)),
                separatorBuilder: (context, index) => SizedBox(
                      width: 15,
                    ),
                itemCount: 20),
          )
          // Text("hjvsdbvjjsdf"),
        ],
      ),
    );
  }
}
