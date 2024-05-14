import 'package:flutter/material.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';

class TimerWidget extends StatefulWidget {
  final TimeStorage timeStorage;
  final VoidCallback onRecord;

  TimerWidget({Key? key, required this.timeStorage, required this.onRecord}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String timeString = "00:00:00";
  bool isRunning = false;
  bool isPaused = false; // 타이머가 중지된 상태를 관리

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
      widget.timeStorage.startTimer(updateTime);
      setState(() {
        isRunning = true;
        isPaused = false;
      });
    } else {
      widget.timeStorage.stopTimer();
      setState(() {
        isRunning = false;
        isPaused = true;
      });
    }
  }

  void _restartTimer() {
    widget.timeStorage.resetTimer();
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
          title: Text('Record Session'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Enter session name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.timeStorage.recordTime(_nameController.text.trim().isEmpty ? "Unnamed Session" : _nameController.text.trim());
                widget.onRecord();
                Navigator.of(context).pop();
              },
              child: Text('Record'),
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
                  backgroundColor: Color(0xFF3A6351), // 배경색
                  foregroundColor: Colors.white, // 글자색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text(isRunning ? 'Stop' : (isPaused ? 'Restart' : 'Start')),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _restartTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A6351), // 배경색
                  foregroundColor: Colors.white, // 글자색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: Text('Restart'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: _recordTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3A6351), // 배경색
                  foregroundColor: Colors.white, // 글자색
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
