

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantory/views/home/home_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/plant.dart';



late final ValueNotifier<List<Plant>> _selectedEvents;

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Calendar();
  }

}

class _Calendar extends State<Calendar>{

  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  List<DateTime> cycleList = [];
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
    _selectedEvents = ValueNotifier(plantList);

    for(int i = 0; DateTime.now().add(Duration(days: i)).isBefore(DateTime(DateTime.now().year+1).subtract(Duration(days: 1)));
    i+= int.parse(plantList[0].cycles![0]["cycle"])){
      cycleList.add(DateFormat('yyyy-MM-dd').parse(DateTime.now().add(Duration(days: i)).toString()));
    }
  }

  List<Plant> _getEventsForDay(DateTime day) {
    // Implementation example
    for(DateTime i in cycleList){
      if(DateFormat('yyyy-MM-dd').parse(i.toString()) == DateFormat('yyyy-MM-dd').parse(day.toString())){
        return [plantList[0]];
      }else{
      }
    }
    return[];
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
        TableCalendar<Plant>(
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
          child: ValueListenableBuilder<List<Plant>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      onTap: () => print('${value[index].name}'),
                      title: Text(' ${ value[index].name}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
