

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantory/views/home/home_page.dart';
import 'package:plantory/views/plant/plant_detail_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicons/unicons.dart';

import '../../data/plant.dart';



late final ValueNotifier<List<Map>> _selectedEvents;

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Calendar();
  }

}

class _Calendar extends State<Calendar>{

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

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    for(var j in plantList){

      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![0]["startDate"]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![0]["cycle"])){
        wateringDays.add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![0]["startDate"])
            .add(Duration(days: i)).toString()));
      }
      for(int i = 0; DateFormat('yyyy-MM-dd').parse(j.cycles![1]["startDate"]).add(Duration(days: i))
          .isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1))); i+= int.parse(j.cycles![1]["cycle"])){
        repottingDays.add(DateFormat('yyyy-MM-dd').parse(DateFormat('yyyy-MM-dd').parse(j.cycles![1]["startDate"])
            .add(Duration(days: i)).toString()));
      }

    }
    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));

  }

  List<Map> _getEventsForDay(DateTime day) {
    // Implementation example
    List<Map> result = List.empty(growable: true);
    for(DateTime i in wateringDays){
      if(DateFormat('yyyy-MM-dd').parse(i.toString()) == DateFormat('yyyy-MM-dd').parse(day.toString())){
        result.add({"plant" : plantList[0] , "cycle" : "물"});
      }
    }
    for(DateTime i in repottingDays){
      if(DateFormat('yyyy-MM-dd').parse(i.toString()) == DateFormat('yyyy-MM-dd').parse(day.toString())){
        result.add({"plant" : plantList[0] , "cycle" : "분갈이"});
      }
    }
    return result;
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Column(
      children: [
        TableCalendar<Map>(
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
          onFormatChanged: (format) {

          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true
          ),
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          onDaySelected: _onDaySelected,
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<Map>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return value.isNotEmpty ? ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    child:ListTile(
                        leading: Icon(value[index]["cycle"] == "물" ? Icons.water_drop : UniconsLine.shovel),
                        title: Text('${ value[index]["plant"].name}'),
                        subtitle: Text(value[index]["cycle"]),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black38, width: 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onTap: (() => Navigator.of(context).push(MaterialPageRoute(builder: ((context) =>
                            PlantDetailPage(plant: value[index]["plant"]))) )
                        )
                    ),
                  );
                },
              ) : Container(
                child: Center(child: Text("해당일에 일정이 존재하지 않습니다.")),
              );
            },
          ),
        ),
      ],
    );
  }

}
