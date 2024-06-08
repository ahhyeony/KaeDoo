import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_ctimestorage.dart';

class CTimerWidget extends StatefulWidget {
  final VoidCallback onRecord;

  CTimerWidget({Key? key, required this.onRecord}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<CTimerWidget> {
  final CTimeStorage timeStorage = CTimeStorage();
  String timeString = "00:00:00";
  bool isRunning = false;
  bool isPaused = false;

  void updateTime(Duration duration) {
    setState(() {
      timeString = formatDuration(duration);
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  void _startStopTimer() {
    if (!isRunning) {
      timeStorage.startTimer(updateTime);
      setState(() {
        isRunning = true;
        isPaused = false;
      });
    } else {
      timeStorage.stopTimer();
      setState(() {
        isRunning = false;
        isPaused = true;
      });
    }
  }

  void _restartTimer() {
    timeStorage.resetTimer();
    updateTime(Duration.zero);
    setState(() {
      isRunning = false;
      isPaused = false;
    });
  }

  void _recordTime() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _nameController = TextEditingController();
        return AlertDialog(
          title: Text('시간 기록'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: '과목명을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                timeStorage.recordTime(
                    _nameController.text.trim().isEmpty ? "Unnamed Session" : _nameController.text.trim());
                print("Time recorded: ${timeStorage.getTimeLogs()}"); // 로그 추가
                widget.onRecord();
                Navigator.of(context).pop();
                _restartTimer(); // 자동으로 타이머 초기화
              },
              child: Text('기록'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF94B396),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(timeString, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _startStopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A6351),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(isRunning ? 'Stop' : (isPaused ? 'Restart' : 'Start')),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _recordTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A6351),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text('Record'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}