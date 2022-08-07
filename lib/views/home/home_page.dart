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
import '../notification/notification.dart';
import '../plant/plant_detail_page.dart';

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

  PlantNotification plantNotification = PlantNotification();

  final PageController pageController = PageController(initialPage: 0,viewportFraction: 0.85);

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
      ),
      body: PageView.builder(
          itemCount: widget.person.plants!.length +1,
          pageSnapping: true,
          controller: pageController,
          itemBuilder: (context, pagePosition) {
            return Container(
              margin: EdgeInsets.only(left: 5,right: 5,bottom: 20),
              child: GestureDetector(
                onTap: (){
                  Get.to(() => PlantDetailPage(plant:widget.person.plants![pagePosition]!, person: widget.person,))
                      ?.then((value) => setState((){}));
                },
                child:Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: pagePosition <= widget.person.plants!.indexOf(widget.person.plants!.last) ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text("${widget.person.plants![pagePosition]!.name!}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),),
                              Text("  |  "),
                              Text("${widget.person.plants![pagePosition]!.type!}"),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                          Row(
                            children: [
                              Text("${widget.person.plants![pagePosition]!.name!}와 함께한지 ",),
                              Text("${DateFormat('yyyy-MM-dd')
                                  .parse(DateTime.now().toString()).difference(DateFormat('yyyy-MM-dd')
                                  .parse(widget.person.plants![pagePosition]!.date!)).inDays}일이 지났어요!",
                                style: TextStyle(fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ],
                      ) : Align(
                        alignment: Alignment.center,
                        child: Text("새로운 식물 추가하기",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                    ),
                    pagePosition != widget.person.plants!.length ? Expanded(
                      child: Card(
                        elevation: 2,
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
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset("assets/images/default_plant6_512.png",
                                width: MediaQuery.of(context).size.width * 0.5,),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                widget.person.plants![pagePosition]!.image != null ?
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: Image.memory(base64Decode(widget.person.plants![pagePosition]!.image!), fit: BoxFit.cover,).image,
                                          )
                                      ),
                                    ),
                                  ),
                                ) :
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          border: Border.all(color: Colors.black26),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft:Radius.circular(10),
                                        bottomRight:Radius.circular(10)
                                    ),
                                    color: Color(0xffC9D9CF)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          cycleTile(widget.person.plants![pagePosition]!, pagePosition, CycleType.watering),
                                          cycleTile(widget.person.plants![pagePosition]!, pagePosition, CycleType.repotting),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ) : Expanded(
                      child: GestureDetector(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Center(
                                        child: Icon(Icons.add,size: MediaQuery.of(context).size.width * 0.1,color: Colors.black54,)

                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft:Radius.circular(10),
                                        bottomRight:Radius.circular(10)
                                    ),
                                    color: Color(0xffC9D9CF)
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: (){
                          Get.to(() => PlantAddPage(person: widget.person,))?.then((value) => setState((){}));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
    );
  }

  Widget cycleTile(Plant plant, int position, CycleType cycleType){

    return GestureDetector(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:8,top: 8,bottom: 8),
              child: cycleType == CycleType.watering ? Icon(Icons.water_drop,color: Colors.black87,) : Icon(UniconsLine.shovel,color: Colors.black87),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cycleType ==  CycleType.watering ? "물" : "분갈이",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87)),
            ),
            (DateFormat('yyyy-MM-dd').parse(plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.initDate.name]))
                .isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString())) &&
                (cycleType == CycleType.watering ? getFastWateringDate(plant.cycles!)
                    : getFastRepottingDate(plant.cycles!)) == plant.cycles![cycleType == CycleType.watering ? 0 : 1][Cycles.cycle.name]
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
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

                  plantNotification.zonedMidnightSchedule(plant.cycles![CycleType.watering.index][Cycles.id.name], "Plantory 알림",
                      "\"${plant.name}\"에게 물을 줄 시간입니다!", getFastWateringDate(plant.cycles!));

                  plantNotification.zonedMidnightSchedule(plant.cycles![CycleType.repotting.index][Cycles.id.name], "Plantory 알림",
                      "\"${plant.name}\"의 분갈이 시간입니다!", getFastRepottingDate(plant.cycles!));

                  }, icon: Icon(Icons.check_circle_outline)),)
                : Padding(padding: const EdgeInsets.all(8.0), child: Text("D${cycleType == CycleType.watering
                  ? -getFastWateringDate(plant.cycles!)
                  : -getFastRepottingDate(plant.cycles!)}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black87),),
                )
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
