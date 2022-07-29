// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';

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
  ),
  Plant(
    id: 1,
    name: "잡초",
    type: "난",
    date: "2022-07-28",
    note: null,
    cycles:[
      {
        "id" : 0,
        "type" : "물",
        "cycle" : "7",
        "startDate" : "2022-07-28",
      },
      {
        "id" : 1,
        "type" : "분갈이",
        "cycle" : "14",
        "startDate" : "2022-07-28",
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

  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.9);
  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffEEF1F1),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffEEF1F1),
        title: const Text(
          "Home",
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: PageView.builder(
          itemCount: plantList.length,
          pageSnapping: true,
          controller: pageController,
          onPageChanged: (page) {

          },
          itemBuilder: (context, pagePosition) {
            return Container(
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(LineIcons.byName('crown',),color: Colors.amber,)
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          ClipOval(
                              child: Image.asset('images/plant1.jpeg',width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.width * 0.6,)
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text("${plantList[pagePosition].type!}", style: TextStyle(),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text("${plantList[pagePosition].name!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft:Radius.circular(30),
                                    topRight:Radius.circular(30)
                                ),
                                color: Color(0xffC9D9CF)
                              ),
                              padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${plantList[pagePosition].name!}와 함께한 날 ",),
                                      Text("D +${DateFormat('yyyy-MM-dd')
                                          .parse(DateTime.now().toString()).difference(DateFormat('yyyy-MM-dd')
                                          .parse(plantList[pagePosition].date!)).inDays}",
                                        style: TextStyle(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Divider(thickness: 1,color: Colors.black38,),
                                  SizedBox(height: 10,),
                                  Card(
                                    color: primaryColor,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(10),
                                                  topRight: Radius.circular(10))),
                                          margin: EdgeInsets.only(left: 10),
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: ListTile(
                                            leading: Icon(Icons.water_drop),
                                            title: Text('물'),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: Colors.black38, width: 1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            trailing: Text("D -"+getFastWateringDate(plantList[pagePosition])),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    color: primaryColor,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Wrap(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(10),
                                                  topRight: Radius.circular(10))),
                                          margin: EdgeInsets.only(left: 10),
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: ListTile(
                                            leading: Icon(UniconsLine.shovel),
                                            title: Text('분갈이'),
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(color: Colors.black38, width: 1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            trailing: Text( "D -"+ getFastRepottingDate(plantList[pagePosition])),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  String getFastWateringDate(Plant plant){
    for(int i = 0; DateFormat('yyyy-MM-dd').parse(plant.cycles![0]["startDate"]).add(Duration(days: i))
        .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(plant.cycles![0]["cycle"])){
      if(DateTime.now().isBefore( DateFormat('yyyy-MM-dd').parse(plant.cycles![0]["startDate"]).add(Duration(days: i)))){
        return  DateFormat('yyyy-MM-dd').parse(plant.cycles![0]["startDate"]).add(Duration(days: i)).difference(DateTime.now()).inDays.toString();
      }

    }
    return "없음";
  }

  String getFastRepottingDate(Plant plant){
    for(int i = 0; DateFormat('yyyy-MM-dd').parse(plant.cycles![1]["startDate"]).add(Duration(days: i))
        .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(plant.cycles![1]["cycle"])){
      if(DateTime.now().isBefore( DateFormat('yyyy-MM-dd').parse(plant.cycles![1]["startDate"]).add(Duration(days: i)))){
        return  DateFormat('yyyy-MM-dd').parse(plant.cycles![1]["startDate"]).add(Duration(days: i)).difference(DateTime.now()).inDays.toString();
      }

    }
    return "없음";
  }

}
