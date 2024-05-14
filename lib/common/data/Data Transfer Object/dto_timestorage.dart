class TimeStorage {
  List<Map<String, String>> timeLogs = [];

  void addTimeLog(String date, String time, String name) {
    timeLogs.add({'date': date ?? '', 'time': time, 'name': name});
  }

  void removeTimeLog(int index) {
    timeLogs.removeAt(index);
  }

  void updateTimeLog(int index, String newDate, String newTime, String newName) {
    timeLogs[index]['date'] = newDate ?? '';
    timeLogs[index]['time'] = newTime;
    timeLogs[index]['name'] = newName;
  }

  List<Map<String, String>> getTimeLogs() {
    return timeLogs;
  }

  List<Map<String, String>> getTimeLogsByDate(String date) {
    return timeLogs.where((log) => log['date'] == date).toList();
  }

  Map<String, double> getTotalStudyTimeByDay() {
    Map<String, double> dailyTimes = {};
    for (var log in timeLogs) {
      final date = log['date'] ?? '';
      if (date.isEmpty) continue;
      final timeInSeconds = _parseTimeToSeconds(log['time']!);
      dailyTimes.update(date, (existing) => existing + timeInSeconds, ifAbsent: () => timeInSeconds);
    }
    return _convertSecondsToHours(dailyTimes);
  }

  Map<String, double> getTotalStudyTimeByWeek() {
    Map<String, double> weeklyTimes = {};
    for (var log in timeLogs) {
      final date = DateTime.tryParse(log['date'] ?? '');
      if (date == null) continue;
      final weekYear = _getWeekYear(date);
      final timeInSeconds = _parseTimeToSeconds(log['time']!);
      weeklyTimes.update(weekYear, (existing) => existing + timeInSeconds, ifAbsent: () => timeInSeconds);
    }
    return _convertSecondsToHours(weeklyTimes);
  }

  Map<String, double> getTotalStudyTimeByMonth() {
    Map<String, double> monthlyTimes = {};
    for (var log in timeLogs) {
      final date = DateTime.tryParse(log['date'] ?? '');
      if (date == null) continue;
      final monthYear = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      final timeInSeconds = _parseTimeToSeconds(log['time']!);
      monthlyTimes.update(monthYear, (existing) => existing + timeInSeconds, ifAbsent: () => timeInSeconds);
    }
    return _convertSecondsToHours(monthlyTimes);
  }

  double _parseTimeToSeconds(String time) {
    final parts = time.split(':');
    final hours = double.tryParse(parts[0]) ?? 0;
    final minutes = double.tryParse(parts[1]) ?? 0;
    final seconds = double.tryParse(parts[2]) ?? 0;
    return hours * 3600 + minutes * 60 + seconds;
  }

  Map<String, double> _convertSecondsToHours(Map<String, double> timesInSeconds) {
    return timesInSeconds.map((key, value) => MapEntry(key, value / 3600));
  }

  String _getWeekYear(DateTime date) {
    // 연의 첫 번째 날을 구합니다.
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);

    // 연중 몇 번째 날인지 계산합니다.
    int dayOfYear = date.difference(firstDayOfYear).inDays + 1;

    // 주차를 계산합니다.
    int weekOfYear = ((dayOfYear - date.weekday + 10) / 7).floor();

    // 연도와 주차를 문자열로 반환합니다.
    return '${date.year}-W$weekOfYear';
  }
}
