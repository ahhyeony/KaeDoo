import 'package:flutter/material.dart';
import 'package:kaedoo/common/widget/w_timer.dart';  // TimerWidget을 포함한 파일의 경로가 정확해야 합니다.
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/widget/w_timerecord.dart';
import 'package:kaedoo/screen/main/tab/camera/f_camera.dart';

class TimerFragment extends StatefulWidget {
  TimerFragment({Key? key}) : super(key: key);

  @override
  _TimerFragmentState createState() => _TimerFragmentState();
}

class _TimerFragmentState extends State<TimerFragment> {
  final TimeStorage timeStorage = TimeStorage(); // 싱글톤 인스턴스를 사용합니다.

  void _updateRecords() {
    setState(() {});
  }

  void _navigateToCameraFragment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraFragment()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Timer',
          style: TextStyle(color: Colors.white, fontFamily: 'Jomhuria', fontSize: 50),
        ),
        backgroundColor: Color(0xFF94B396),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _navigateToCameraFragment,
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF0F0F0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: TimerWidget(
                onRecord: _updateRecords,
              ),
            ),
            Expanded(
              child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TimeRecordWidget(timeStorage: timeStorage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
