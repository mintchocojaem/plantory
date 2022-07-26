// ignore_for_file: prefer_const_constructors

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';

List<Plant> plantList = [
  Plant(
    id: 0,
    name: "로꼬",
    type: "해바라기",
    date: DateTime.now(),
    note: null,
    cycles: null,
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
              padding: const EdgeInsets.only(top: 28, bottom: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text('다육이', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      Text('D-25', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ClipOval(child: Image.asset('images/plant1.jpeg',width: 128,height: 128,)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24,right: 24),
              child: Divider(thickness: 1,),
            ),
            Expanded(
              child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffE5E6E0),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: ListTile(title: Text("Plant"),subtitle: Text("물주기"),)
                      ),
                    ),
                  ]
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        heroTag: null,
        child: Icon(Icons.chat,size: 40,),),
    );
  }
}
