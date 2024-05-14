import 'dart:async';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timerecord.dart';

class TimeStorage {
  Duration duration = Duration.zero;
  Timer? _timer;
  List<TimeRecord> timeLogs = [];

  void startTimer(Function(Duration) tick) {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        duration += Duration(seconds: 1);
        tick(duration);
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetTimer() {
    stopTimer();
    duration = Duration.zero;
  }

  void recordTime(String name) {
    if (name.isNotEmpty && duration.inSeconds > 0) {
      String date = DateTime.now().toIso8601String().split('T')[0];
      String timeString = _formatDuration(duration);
      timeLogs.add(TimeRecord(name: name, time: timeString, date: date));
    }
  }

  void updateRecord(int index, String name) {
    timeLogs[index] = TimeRecord(
      name: name,
      time: timeLogs[index].time,
      date: timeLogs[index].date,
    );
  }

  void deleteRecord(int index) {
    timeLogs.removeAt(index);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  List<TimeRecord> getTimeLogs() {
    return timeLogs;
  }
}
