import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_ctimestorage.dart';
import 'package:kaedoo/common/widget/w_timedata.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:kaedoo/common/widget/w_wtimedata.dart';

class CalendarFragment extends StatefulWidget {
  CalendarFragment({Key? key}) : super(key: key);

  @override
  _CalendarFragmentState createState() => _CalendarFragmentState();
}

class _CalendarFragmentState extends State<CalendarFragment> {
  final TimeStorage timeStorage = TimeStorage();
  final CTimeStorage ctimeStorage = CTimeStorage();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String selectedDate = _selectedDay.toIso8601String().split('T')[0];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Calendar',
          style: TextStyle(color: Colors.white, fontFamily: 'Jomhuria', fontSize: 50),
        ),
        backgroundColor: Color(0xFF94B396),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF0F0F0),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 400.0,  // 캘린더의 높이를 조절하여 더 크게 설정
                  child: TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2099, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // update `_focusedDay` here as well
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF94B396),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red),
                      defaultTextStyle: TextStyle(color: Colors.black87),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: TimeDataWidget(
                  timeStorage: timeStorage,
                  cTimeStorage: ctimeStorage,
                  selectedDate: selectedDate,
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: WeeklyDataWidget(
                    timeStorage: timeStorage,
                    cTimeStorage: ctimeStorage,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
