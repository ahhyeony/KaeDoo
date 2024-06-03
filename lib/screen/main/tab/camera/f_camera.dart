import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/common/widget/w_timer.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_timestorage.dart';
import 'package:kaedoo/common/widget/w_timerecord.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_cameraimagedetection.dart';
import 'package:kaedoo/common/widget/w_face_detector.dart';

class CameraFragment extends StatefulWidget {
  CameraFragment({Key? key}) : super(key: key);

  @override
  _CameraFragmentState createState() => _CameraFragmentState();
}

class _CameraFragmentState extends State<CameraFragment> {
  final TimeStorage timeStorage = TimeStorage(); // 싱글톤 인스턴스를 사용합니다.
  CameraImageDetection? _cameraImageDetection;
  CameraController? _cameraController;
  final GlobalKey<FaceDetectionState> faceDetectionKey = GlobalKey<FaceDetectionState>();

  void _updateRecords() {
    setState(() {});
  }

  void _startImageDetection() async {
    _cameraImageDetection = CameraImageDetection(_cameraController!, faceDetectionKey);
    _cameraImageDetection!.startDetection();
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
    CameraDescription? frontCamera;


    // 전면 카메라를 찾습니다.
    frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.nv21 // for Android
    );

    try {
      await _cameraController!.initialize();
      print("Camera initialized.");
      setState(() {});
      _startImageDetection(); // 이미지 추출 시작
    } catch (e) {
      print("카메라 초기화 중 오류 발생: $e");
    }
  }

  @override
  void dispose() {
    _stopImageDetection(); // 이미지 추출 중지
    _cameraController?.dispose();
    print("카메라 컨트롤러 해제.");
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 300.0,  // 카메라 위젯의 높이를 고정
                child: Center(
                  child: _cameraController == null || !_cameraController!.value.isInitialized
                      ? Center(child: CircularProgressIndicator())
                      : CameraPreview(_cameraController!),
                ),
              ),
              Positioned.fill(
                child: FaceDetection(key: faceDetectionKey), // FaceDetection 위젯 추가
              ),
            ],
          ),
          Expanded(
            child: Container(
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
          ),
        ],
      ),
    );
  }
}