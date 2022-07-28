// ignore_for_file: prefer_const_constructors

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';

import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';

List<Plant> plantList = [
  Plant(
    id: 0,
    name: "로꼬",
    type: "다육이",
    date: "2022-07-27",
    note: null,
    cycles:[
      {
        "id" : 0,
        "type" : "물",
        "cycle" : "14",
        "startDate" : "2022-07-27",
      },
      {
        "id" : 1,
        "type" : "분갈이",
        "cycle" : "30",
        "startDate" : "2022-07-27",
      },
    ],
  )
];

class HomePage extends StatefulWidget{

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }

}

class _HomePage extends State<HomePage>{

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Home",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ClipOval(child: Image.asset('images/plant1.jpeg',width: 256,height: 256,)),
                      SizedBox(height: 20),
                      Text("${plantList[0].type!}", style: TextStyle(),),
                      SizedBox(height: 10),
                      Text("${plantList[0].name!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 32, left: 32),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
                          child: Column(
                            children: [
                              Text("${plantList[0].type!}와 함께한 날 D +${DateFormat('yyyy-MM-dd')
                                  .parse(DateTime.now().toString()).difference(DateFormat('yyyy-MM-dd')
                                  .parse(plantList[0].date!)).inDays}"),
                              Divider(thickness: 1,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
