import 'dart:async';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timerecord.dart'; // TimeRecord 클래스를 올바르게 import

class CTimeStorage {
  Duration duration = Duration.zero;
  Duration sleepDuration = Duration.zero; // 졸음 감지 시간을 기록할 변수 추가
  Timer? _timer;
  List<TimeRecord> timeLogs = [];

  // 싱글톤 인스턴스
  static final CTimeStorage _instance = CTimeStorage._internal();

  // private 생성자
  CTimeStorage._internal();

  // 인스턴스를 반환하는 팩토리 생성자
  factory CTimeStorage() {
    return _instance;
  }

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
      String timeString = _formatDuration(duration - sleepDuration); // 졸음 시간을 제외한 시간
      timeLogs.add(TimeRecord(name: name, time: timeString, date: date));
      print("Record added: ${timeLogs.last}"); // 로그 추가
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

  void addSleepDuration(Duration sleepTime) {
    sleepDuration += sleepTime;
  }

  bool isTimerRunning() {
    return _timer != null;
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  List<TimeRecord> getTimeLogs() {
    return timeLogs;
  }
}