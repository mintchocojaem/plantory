

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:plantory/utils/colors.dart';
import 'package:plantory/views/plant/plant_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:unicons/unicons.dart';
import '../../data/plant.dart';


class Calendar extends StatefulWidget {
  final List<Plant> plantList;

  const Calendar({Key? key, required this.plantList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Calendar();
  }

}

class _Calendar extends State<Calendar>{

   ValueNotifier<List<Map>>? _selectedEvents;

  List<Map> plants = List.empty(growable: true);
  List<DateTime> wateringDays = List.empty(growable: true);
  List<DateTime> repottingDays = List.empty(growable: true);

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
    for(var j in widget.plantList){
      Map temp = {
        "plant" : j,
        "wateringDays" : List.empty(growable: true),
        "repottingDays" : List.empty(growable: true),
      };
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![0][Cycles.cycle.name])){

        if(!DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["wateringDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name])
              .add(Duration(days: i)).toString()));

        }

      }
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![1][Cycles.cycle.name])){

        if(!DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["repottingDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name])
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
      for(DateTime i in j["repottingDays"]){
        if(DateFormat('yyyy-MM-dd').parse(i.toString()) == DateFormat('yyyy-MM-dd').parse(day.toString())){
          result.add({"plant" : j["plant"] , "cycle" : "분갈이"});
        }
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
    for(var j in widget.plantList){
      Map temp = {
        "plant" : j,
        "wateringDays" : List.empty(growable: true),
        "repottingDays" : List.empty(growable: true),
      };
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![0][Cycles.cycle.name])){

        if(!DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["wateringDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![0][Cycles.startDate.name])
              .add(Duration(days: i)).toString()));

        }

      }
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![1][Cycles.cycle.name])){

        if(!DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name])
            .add(Duration(days: i)).isBefore(DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()))){

          temp["repottingDays"].add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![1][Cycles.startDate.name])
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
                  leading: Icon(Icons.calendar_month_outlined),
                  title: Text(DateFormat('yyyy-MM-dd').format(_selectedDay!)),
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
                  return AnimationLimiter(
                    child: ListView.builder(
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
                              iconData: value[index]["cycle"] == "물주기" || value[index]["cycle"] == "분갈이"
                                  ? Icons.notifications_active : Icons.edit_note
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
                                      child: ListTile(
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
                                                color: Color(0xffEEF1F1),
                                                borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width * 0.15))),
                                            child: Icon(UniconsLine.flower,size: MediaQuery.of(context).size.width * 0.12,color: Colors.black54,)
                                        ),
                                        title: Text('${ value[index]["plant"].name}'),
                                        subtitle: Text(value[index]["cycle"]),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black38, width: 1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        trailing: Icon(value[index]["cycle"] == "물주기" ? Icons.water_drop : UniconsLine.shovel),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
