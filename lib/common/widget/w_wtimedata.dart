import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timerecord.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_ctimestorage.dart';
import 'package:pie_chart/pie_chart.dart';

class WeeklyDataWidget extends StatelessWidget {
  final TimeStorage timeStorage;
  final CTimeStorage cTimeStorage;

  WeeklyDataWidget({Key? key, required this.timeStorage, required this.cTimeStorage}) : super(key: key);

  Map<String, double> _createWeeklyDataMap(List<TimeRecord> timeLogs, List<TimeRecord> cTimeLogs, Duration totalSleeping) {
    Map<String, double> dataMap = {};

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    double totalTime = 0.0;
    double cTotalTime = 0.0;

    for (var record in timeLogs) {
      DateTime recordDate = DateTime.parse(record.date);
      if (recordDate.isAfter(startOfWeek) && recordDate.isBefore(endOfWeek)) {
        totalTime += _parseTimeToMinutes(record.time);
      }
    }

    for (var record in cTimeLogs) {
      DateTime recordDate = DateTime.parse(record.date);
      if (recordDate.isAfter(startOfWeek) && recordDate.isBefore(endOfWeek)) {
        cTotalTime += _parseTimeToMinutes(record.time);
      }
    }

    double totalStudyTime = totalTime + cTotalTime;
    double totalSleepingMinutes = totalSleeping.inMinutes.toDouble();

    dataMap['Study Time'] = totalStudyTime;
    dataMap['Total Sleeping'] = totalSleepingMinutes;

    return dataMap;
  }

  double _parseTimeToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 60 + minutes + seconds / 60;
  }

  @override
  Widget build(BuildContext context) {
    List<TimeRecord> timeLogs = timeStorage.getTimeLogs();
    List<TimeRecord> cTimeLogs = cTimeStorage.getTimeLogs();
    Map<String, double> dataMap = _createWeeklyDataMap(timeLogs, cTimeLogs, cTimeStorage.totalSleeping);

    double totalStudyTime = dataMap['Study Time']!;
    double totalSleepingTime = dataMap['Total Sleeping']!;
    double totalTime = totalStudyTime + totalSleepingTime;
    double studyTimePercentage = (totalStudyTime / totalTime) * 100;
    double sleepingTimePercentage = (totalSleepingTime / totalTime) * 100;

    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '공부 효율',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          SizedBox(
            height: 280.0,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: dataMap.isEmpty
                        ? Opacity(
                      opacity: 0.3,
                      child: PieChart(
                        dataMap: {"No Data": 1},
                        chartType: ChartType.ring,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        ringStrokeWidth: 32,
                        centerText: "No Data",
                        legendOptions: LegendOptions(
                          showLegends: false,
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValues: false,
                        ),
                        colorList: [Colors.grey],
                      ),
                    )
                        : PieChart(
                      dataMap: {
                        "Study Time": studyTimePercentage,
                        "Sleeping Time": sleepingTimePercentage
                      },
                      chartType: ChartType.ring,
                      chartRadius: MediaQuery.of(context).size.width / 2.5,
                      ringStrokeWidth: 32,
                      centerText: "Weekly Time",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.left,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '일간 공부효율',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '${totalStudyTime.toStringAsFixed(2)} 분',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
