import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _seconds = 0;

  void _startTimer() {
    if (_timer != null && _timer.isActive) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      setState(() {
        _seconds = 0;
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Elapsed Time: $_seconds seconds', style: Theme.of(context).textTheme.headline4),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startTimer,
              child: Text('Start'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _stopTimer,
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
