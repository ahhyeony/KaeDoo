import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timerecord.dart';
import 'package:pie_chart/pie_chart.dart';

class TimeDataWidget extends StatelessWidget {
  final TimeStorage timeStorage;
  final String selectedDate;

  TimeDataWidget({Key? key, required this.timeStorage, required this.selectedDate}) : super(key: key);

  Map<String, double> _createDataMap(List<TimeRecord> timeLogs) {
    Map<String, double> dataMap = {};

    for (var record in timeLogs) {
      if (record.date == selectedDate) {
        if (dataMap.containsKey(record.name)) {
          dataMap[record.name] = dataMap[record.name]! + _parseTimeToMinutes(record.time);
        } else {
          dataMap[record.name] = _parseTimeToMinutes(record.time);
        }
      }
    }

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
    Map<String, double> dataMap = _createDataMap(timeLogs);

    double totalStudyTime = dataMap.values.fold(0, (sum, item) => sum + item);

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
            '일간 통계',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          SizedBox(
            height: 220.0, // 그래프를 포함한 전체 높이를 더 크게 설정
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // 그래프 위아래에 패딩 추가
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: dataMap.isEmpty
                        ? Opacity(
                      opacity: 0.3,
                      child: PieChart(
                        dataMap: {"No Data": 1},
                        chartType: ChartType.ring,
                        chartRadius: MediaQuery.of(context).size.width / 3,
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
                      dataMap: dataMap,
                      chartType: ChartType.ring,
                      chartRadius: MediaQuery.of(context).size.width / 3,
                      ringStrokeWidth: 32,
                      centerText: "Study Time",
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
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '총 일간 공부시간',
                        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${totalStudyTime.toStringAsFixed(2)} 분',
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
