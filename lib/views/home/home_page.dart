import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:plantory/views/index_page.dart';
import 'package:plantory/views/plant/plant_add_page.dart';
import 'package:unicons/unicons.dart';
import '../../../data/plant.dart';
import '../../../utils/colors.dart';
import '../../data/person.dart';

class HomePage extends StatefulWidget{

  HomePage({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }

}

class _HomePage extends State<HomePage>{


  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.9);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    widget.person.plants!.sort((a, b) {
      if(b!.pinned!) {
        return 1;
      }
      return -1;
    });

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
      body: widget.person.plants!.isNotEmpty ? PageView.builder(
          itemCount: widget.person.plants!.length,
          pageSnapping: true,
          controller: pageController,
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
                    widget.person.plants![pagePosition]!.pinned == true ? Positioned(
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
                    ) : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Center(
                            child: widget.person.plants![pagePosition]!.image != null ? ClipOval(
                                child: Image.memory(base64Decode(widget.person.plants![pagePosition]!.image!),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  height: MediaQuery.of(context).size.width * 0.6,
                                  fit: BoxFit.cover,
                                )
                            ) :
                            Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: MediaQuery.of(context).size.width * 0.6,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.6))),
                                child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.15,color: Colors.black54,)
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text("${widget.person.plants![pagePosition]!.type!}", style: TextStyle(),),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text("${widget.person.plants![pagePosition]!.name!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
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
                                      Text("${widget.person.plants![pagePosition]!.name!}와 함께한지 ",),
                                      Text("${DateFormat('yyyy-MM-dd')
                                          .parse(DateTime.now().toString()).difference(DateFormat('yyyy-MM-dd')
                                          .parse(widget.person.plants![pagePosition]!.date!)).inDays}일이 지났어요!",
                                        style: TextStyle(fontWeight: FontWeight.w500),)
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Divider(thickness: 1,color: Colors.black38,),
                                  SizedBox(height: 10,),
                                  cycleTile(widget.person.plants![pagePosition]!, pagePosition, CycleType.watering),
                                  cycleTile(widget.person.plants![pagePosition]!, pagePosition, CycleType.repotting)
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
          }) : Center(
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
    );
  }

  Widget cycleTile(Plant plant, int position, CycleType cycleType){

    return GestureDetector(
      child: Card(
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
                  leading: cycleType == CycleType.watering ? Icon(Icons.water_drop) : Icon(UniconsLine.shovel),
                  title: Text(cycleType ==  CycleType.watering ? "물" : "분갈이"),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black38, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  trailing: (DateFormat('yyyy-MM-dd').parse(plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.initDate.name]))
                      .isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())) &&
                      (cycleType == CycleType.watering ? getFastWateringDate(plant.cycles!)
                          : getFastRepottingDate(plant.cycles!)) == plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name]
                      ? IconButton(
                      onPressed: () async{
                        setState((){
                          plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.initDate.name]
                          = DateFormat('yyyy-MM-dd').format(DateTime.now()
                              .add(Duration(days: int.parse(plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name].toString()))));
                        });
                        var usersCollection = firestore.collection('users');
                        await usersCollection.doc(widget.person.uid).update(
                            {
                              "plants": widget.person.plantsToJson(widget.person.plants!)
                            });
                      },
                      icon: Icon(Icons.check_circle_outline)
                  )
                      : Text("D ${cycleType == CycleType.watering
                      ? -getFastWateringDate(plant.cycles!)
                      : -getFastRepottingDate(plant.cycles!)}")
              ),
            ),
          ],
        ),
      ),
    );
  }

}

int getFastWateringDate(List cycles){
  for(int i = 0; DateFormat('yyyy-MM-dd').parse(cycles[0][Cycles.startDate.name]).add(Duration(days: i))
      .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(cycles[0][Cycles.cycle.name].toString())){

    if(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).isBefore( DateFormat('yyyy-MM-dd')
        .parse(cycles[CycleType.watering.index][Cycles.startDate.name]).add(Duration(days: i)))){

      return  DateFormat('yyyy-MM-dd').parse(cycles[0][Cycles.startDate.name]).add(Duration(days: i))
          .difference(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())).inDays;

    }

  }
  return 0;
}

int getFastRepottingDate(List cycles){
  for(int i = 0; DateFormat('yyyy-MM-dd').parse(cycles[1][Cycles.startDate.name]).add(Duration(days: i))
      .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(cycles[1][Cycles.cycle.name].toString())){

    if(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()).isBefore( DateFormat('yyyy-MM-dd')
        .parse(cycles[1][Cycles.startDate.name]).add(Duration(days: i)))){

      return  DateFormat('yyyy-MM-dd').parse(cycles[1][Cycles.startDate.name]).add(Duration(days: i))
          .difference(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())).inDays;

    }

  }
  return 0;
}
