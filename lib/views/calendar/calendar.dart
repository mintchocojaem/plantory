

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:plantory/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:unicons/unicons.dart';
import '../../data/person.dart';
import '../../data/plant.dart';


class Calendar extends StatefulWidget {

  const Calendar({Key? key, required this.person}) : super(key: key);

  final Person person;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Calendar();
  }

}

class _Calendar extends State<Calendar>{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ValueNotifier<List<Map>>? _selectedEvents;

  List<Map> plants = List.empty(growable: true);
  List<DateTime> wateringDays = List.empty(growable: true);

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {

    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;

      });
      _selectedEvents!.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    for(var j in widget.person.plants!){
      Map temp = {
        "plant" : j,
        "wateringDays" : List.empty(growable: true),
      };
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j!.watering![Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.watering![Cycles.cycle.name].toString())){

        if(!DateFormat('yyyy-MM-dd').parse(j.watering![Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["wateringDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.watering![Cycles.startDate.name])
              .add(Duration(days: i)).toString()));

        }

      }
      plants.add(temp);
    }
    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));
  }

  List<Map> _getEventsForDay(DateTime day) {
    // Implementation example
    List<Map> result = List.empty(growable: true);
    for(Map j in plants){
      for(DateTime i in j["wateringDays"]){
        if(DateFormat('yyyy-MM-dd').parse(i.toString()) == DateFormat('yyyy-MM-dd').parse(day.toString())){
          result.add({"plant" : j["plant"] , "cycle" : "물주기"});
        }
      }

      if(j["plant"].timelines.isNotEmpty) {
        for(Map i in j["plant"].timelines){
          if(DateFormat('yyyy-MM-dd').parse(i["date"]) == DateFormat('yyyy-MM-dd').parse(day.toString())){
            result.add({"plant" : j["plant"],"timelines" : i, "cycle" : null});
          }}
      }

    }
    return result;
  }

  @override
  void dispose() {
    _selectedEvents!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    plants = List.empty(growable: true);
    for(var j in widget.person.plants!){
      Map temp = {
        "plant" : j,
        "wateringDays" : List.empty(growable: true),
      };
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j!.watering![Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.watering![Cycles.cycle.name].toString())){

        if(!DateFormat('yyyy-MM-dd').parse(j.watering![Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["wateringDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.watering![Cycles.startDate.name])
              .add(Duration(days: i)).toString()));

        }

      }

      plants.add(temp);
    }
    _selectedEvents!.value = _getEventsForDay(_selectedDay!);


    // TODO: implement build
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  leading: Icon(Icons.calendar_month_outlined,color: Color(0xff404040),),
                  title: Text(DateFormat('yyyy-MM-dd').format(_selectedDay!),style: TextStyle(color: Color(0xff404040)),),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      child: TableCalendar<Map>(
                        firstDay: DateTime(DateTime.now().year), //시작일
                        lastDay: DateTime(DateTime.now().year+1).subtract(Duration(days: 1)), //마지막일
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        eventLoader: _getEventsForDay,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                        ),
                        headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                          titleCentered: true
                        ),
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        onDaySelected: _onDaySelected,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            _selectedEvents!.value.isNotEmpty ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ValueListenableBuilder<List<Map>>(
                valueListenable: _selectedEvents!,
                builder: (context, value, _) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return TimelineTile(
                        alignment: TimelineAlign.start,
                        afterLineStyle: LineStyle(
                          color: primaryColor
                        ),
                        beforeLineStyle: LineStyle(
                          color: primaryColor
                        ),
                        indicatorStyle: IndicatorStyle(
                          color: primaryColor,
                          width: 24,
                          iconStyle: IconStyle(
                            color: Colors.white,
                            iconData: value[index]["cycle"] != null ? value[index]["cycle"] == "물주기"
                                ? Icons.notifications_active : Icons.edit_note : Icons.edit_calendar_outlined
                          ),
                        ),
                        endChild: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              horizontalOffset: 400.0,
                              child: FadeInAnimation(
                                child: Card(
                                  color: Color(0xffC9D9CF),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    margin: EdgeInsets.only(left: 10),
                                    child: value[index]["cycle"] != null ? ListTile(
                                      leading: value[index]["plant"].image != null ? ClipOval(
                                          child: Image.memory(base64Decode(value[index]["plant"].image),
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            height: MediaQuery.of(context).size.width * 0.15,
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                          )
                                      ) :
                                      Container(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          height: MediaQuery.of(context).size.width * 0.15,
                                          decoration: BoxDecoration(
                                              color: Color(0xffC9D9CF),
                                              borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.14))),
                                          child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.08,color: Colors.black54,)
                                      ),
                                      title: Text('${ value[index]["plant"].name}'),
                                      subtitle: Text(value[index]["cycle"]),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.black38, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      trailing: value[index]["cycle"] != null ? SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.1,
                                        height: MediaQuery.of(context).size.width * 0.1,
                                        child: IconButton(
                                          icon: value[index]["cycle"] == "물주기" ? Icon(Icons.water_drop) : Icon(UniconsLine.shovel),
                                          onPressed: (){

                                            },),
                                      ) : Container(),
                                    ) : Theme(
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            leading: value[index]["plant"].image != null ? ClipOval(
                                                child: Image.memory(base64Decode(value[index]["plant"].image),
                                                  width: MediaQuery.of(context).size.width * 0.15,
                                                  height: MediaQuery.of(context).size.width * 0.15,
                                                  fit: BoxFit.cover,
                                                )
                                            ) :
                                            Container(
                                                width: MediaQuery.of(context).size.width * 0.15,
                                                height: MediaQuery.of(context).size.width * 0.15,
                                                decoration: BoxDecoration(
                                                    color: Color(0xffC9D9CF),
                                                    borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.14))),
                                                child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.08,color: Colors.black54,)
                                            ),
                                            title: Text(value[index]["timelines"]["title"]),
                                            subtitle: Text(value[index]["plant"].name),
                                            trailing: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.1,
                                                height: MediaQuery.of(context).size.width * 0.1,
                                                child: IconButton(
                                                  icon: Icon(Icons.delete_outline),
                                                  onPressed: (){
                                                    showDialog(barrierColor: Colors.black54, context: context, builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: const Text("타임라인 삭제"),
                                                        content: Padding(
                                                          padding: const EdgeInsets.only(top: 8),
                                                          child: Text("해당 타임라인을 삭제하시겠습니까?"),
                                                        ),
                                                        actions: [
                                                          CupertinoDialogAction(isDefaultAction: false, child: Text("취소"), onPressed: () {
                                                            Navigator.pop(context);
                                                          }),
                                                          CupertinoDialogAction(isDefaultAction: false, child: const Text("확인",style: TextStyle(color: Colors.red),),
                                                              onPressed: () async {

                                                                widget.person.plants![widget.person.plants!.indexOf(value[index]["plant"])]!.timelines!.remove(value[index]["timelines"]);

                                                                var usersCollection = firestore.collection('users');
                                                                await usersCollection.doc(widget.person.uid).update(
                                                                    {
                                                                      "plants": widget.person.plantsToJson(widget.person.plants!)
                                                                    }).then((value) {
                                                                  setState(() {
                                                                    Get.back();
                                                                  });
                                                                });

                                                              }
                                                          ),
                                                        ],
                                                      );
                                                    });
                                                  },)
                                            ),
                                          ),
                                          value[index]["timelines"]["image"] != null
                                              ? SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image.memory(base64Decode(value[index]["timelines"]["image"]),gaplessPlayback: true,
                                                  fit: BoxFit.cover,),
                                              ),
                                          ) : Container(),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.height * 0.02,
                                              bottom: MediaQuery.of(context).size.height * 0.02,
                                              right: MediaQuery.of(context).size.width * 0.1,
                                              left: MediaQuery.of(context).size.width * 0.1,
                                            ),
                                            child: Center(child: Text( value[index]["timelines"]["content"],style: TextStyle(fontSize: 16),)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ) : SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                    child: Text("해당일에 일정이 존재하지 않습니다.")
              ),
            ),
          ],
        ),
      ),
    );
  }

}
