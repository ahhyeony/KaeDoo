import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timerecord.dart'; // TimeRecord 클래스를 올바르게 import
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_ctimestorage.dart'; // 추가된 import

class RatioDataWidget extends StatelessWidget {
  final TimeStorage timeStorage;
  final CTimeStorage cTimeStorage;
  final String selectedDate;

  RatioDataWidget({Key? key, required this.timeStorage, required this.cTimeStorage, required this.selectedDate}) : super(key: key);

  Map<String, double> _createDataMap(List<TimeRecord> timeLogs, List<TimeRecord> cTimeLogs) {
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

    for (var record in cTimeLogs) {
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

  String _getImageForEfficiency(double efficiency) {
    if (efficiency == 100) {
      return 'assets/image/kaekae/kae100.jpeg';
    } else if (efficiency >= 80) {
      return 'assets/image/kaekae/kae98.jpeg';
    } else if (efficiency >= 60) {
      return 'assets/image/kaekae/kae76.jpeg';
    } else if (efficiency >= 40) {
      return 'assets/image/kaekae/kae54.jpeg';
    } else if (efficiency >= 20) {
      return 'assets/image/kaekae/kae32.jpeg';
    } else if (efficiency > 0) {
      return 'assets/image/kaekae/kae10.jpeg'; // 0퍼센트일 때 이미지 경로
    } else {
      return 'assets/image/kaekae/kae0.jpeg';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TimeRecord> timeLogs = timeStorage.getTimeLogs();
    List<TimeRecord> cTimeLogs = cTimeStorage.getTimeLogs();
    Map<String, double> dataMap = _createDataMap(timeLogs, cTimeLogs);

    double totalStudyTime = dataMap.values.fold(0, (sum, item) => sum + item);
    double totalSleepingTime = cTimeStorage.totalSleeping.inMinutes.toDouble();
    double efficiency = totalStudyTime > 0 ? (totalStudyTime / (totalStudyTime + totalSleepingTime)) * 100 : 0;
    String imagePath = _getImageForEfficiency(efficiency);

    return Container(
      width: double.infinity,
      height: 350.0, // 고정된 높이
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '공부 효율',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imagePath,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.white,
                    );
                  },
                ),
                Text(
                  '일간 공부 효율: ${efficiency.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
