import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/common/widget/w_timer.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/widget/w_timerecord.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_cameraimagedetection.dart';

class CameraFragment extends StatefulWidget {
  CameraFragment({Key? key}) : super(key: key);

  @override
  _CameraFragmentState createState() => _CameraFragmentState();
}

class _CameraFragmentState extends State<CameraFragment> {
  final TimeStorage timeStorage = TimeStorage(); // 싱글톤 인스턴스를 사용합니다.
  CameraImageDetection? _cameraImageDetection;
  CameraController? _cameraController;

  void _updateRecords() {
    setState(() {});
  }

  void _startImageDetection() async {
    _cameraImageDetection = CameraImageDetection(_cameraController!);
    await _cameraImageDetection!.startDetection();
  }

  void _stopImageDetection() {
    _cameraImageDetection?.stopDetection();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    setState(() {});

    _startImageDetection(); // 이미지 추출 시작
  }

  @override
  void dispose() {
    _stopImageDetection(); // 이미지 추출 중지
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Camera & Timer',
          style: TextStyle(color: Colors.white, fontFamily: 'Jomhuria', fontSize: 50),
        ),
        backgroundColor: Color(0xFF94B396),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300.0,  // 카메라 위젯의 높이를 고정
              child: _cameraController == null || !_cameraController!.value.isInitialized
                  ? Center(child: CircularProgressIndicator())
                  : CameraPreview(_cameraController!),
            ),
            Container(
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
                  Container(
                    height: MediaQuery.of(context).size.height - 400,  // 카메라 위젯과 타이머 위젯의 높이를 뺀 나머지 높이
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
