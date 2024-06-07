import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kaedoo/common/data/Data Transfer Object/dto_ctimestorage.dart';

class FaceDetection extends StatefulWidget {
  const FaceDetection({Key? key}) : super(key: key);

  @override
  State<FaceDetection> createState() => FaceDetectionState();
}

class FaceDetectionState extends State<FaceDetection> {
  late final FaceDetector _faceDetector;
  bool _canProcess = true;
  int _faceCount = 0;

  // 눈 검출
  bool isLeftEyeOpen = false;
  bool isRightEyeOpen = false;
  List<Rect> _leftEyeRects = [];
  List<Rect> _rightEyeRects = [];

  // 졸음 체크
  int _closedEyeDuration = 0; // 눈을 감은 시간 (초 단위)
  final int _drowsinessThreshold = 10; // 졸음 체크 임계값 (10초)
  Timer? _drowsinessTimer;
  bool _isDrowsy = false; // 졸음 상태 여부

  @override
  void initState() {
    super.initState();
    _initializeFaceDetector();
    print("initState 호출됨");
  }

  void _initializeFaceDetector() {
    print("FaceDetector 초기화 중");
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.accurate,
        minFaceSize: 0.05, // 감지할 최소 얼굴 크기 (전체 이미지 대비 비율)
      ),
    );
    print("FaceDetector 초기화 완료");
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _drowsinessTimer?.cancel();
    print("FaceDetector disposed.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("FaceDetection build 호출됨. 감지된 얼굴 수: $_faceCount");
    return Stack(
      children: [
        Positioned(
          bottom: 20,
          left: 20,
          child: Column(
            children: [
              Text(
                '감지된 얼굴 수: $_faceCount',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 카메라가 거울모드이므로 서로 인자를 바꾸어줌
              Text(
                'Left Eye: ${isRightEyeOpen ? 'Open' : 'Closed'}',
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
              Text(
                'Right Eye: ${isLeftEyeOpen ? 'Open' : 'Closed'}',
                style: TextStyle(fontSize: 10, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    print("processImage 메서드가 호출되었습니다.");
    // 작업 못 하는 경우
    if (!_canProcess) {
      print("처리할 수 없습니다.");
      return;
    }

    print("이미지 처리 중...");
    print("이미지 메타데이터: ${inputImage.metadata}");
    print("이미지 바이트 길이: ${inputImage.bytes?.length ?? 'null'}");

    final faces = await faceDetector.processImage(inputImage);
    print("얼굴 감지가 완료되었습니다. 감지된 얼굴 수: ${faces.length}");
    for (var face in faces) {
      print("얼굴 위치: ${face.boundingBox}");
    }

    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      // eye detection
      List<Rect> leftEyeRects = [];
      List<Rect> rightEyeRects = [];

      //bool allEyesClosed = faces.isNotEmpty; // 초기값을 얼굴이 감지된 상태로 설정

      for (Face face in faces) {
        if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
          print('Left Eye Open Probability: ${face.leftEyeOpenProbability}');
          print('Right Eye Open Probability: ${face.rightEyeOpenProbability}');

          bool leftEyeClosed = face.leftEyeOpenProbability! < 0.5;
          bool rightEyeClosed = face.rightEyeOpenProbability! < 0.5;

          // 한 사람이라도 눈을 뜨고 있으면 졸음 상태가 아님
          // if (!leftEyeClosed || !rightEyeClosed) {
          //   allEyesClosed = false;
          // }

          setState(() {
            isLeftEyeOpen = !leftEyeClosed;
            isRightEyeOpen = !rightEyeClosed;
          });

          final leftEyePos = face.landmarks[FaceLandmarkType.leftEye]?.position;
          final rightEyePos = face.landmarks[FaceLandmarkType.rightEye]?.position;

          if (leftEyePos != null) {
            leftEyeRects.add(Rect.fromCenter(
              center: Offset(leftEyePos.x.toDouble(), leftEyePos.y.toDouble()), // 변환 적용
              width: 20.0, // 변환 적용
              height: 20.0, // 변환 적용
            ));
          }

          if (rightEyePos != null) {
            rightEyeRects.add(Rect.fromCenter(
              center: Offset(rightEyePos.x.toDouble(), rightEyePos.y.toDouble()), // 변환 적용
              width: 20.0, // 변환 적용
              height: 20.0, // 변환 적용
            ));
          }
        }
      }

      //if (allEyesClosed && CTimeStorage().isTimerRunning()) {
      if (CTimeStorage().isTimerRunning()) {
        if (_drowsinessTimer == null) {
          print("눈이 감겼습니다. 타이머를 시작합니다.");
          _drowsinessTimer = Timer.periodic(Duration(seconds: 1), (timer) {
            _closedEyeDuration += 1;
            print("눈을 감은 시간: $_closedEyeDuration 초");

            if (_closedEyeDuration == _drowsinessThreshold) {
              print('졸음 상태입니다! 눈을 $_drowsinessThreshold 초 이상 감고 있습니다.');
              _isDrowsy = true;
            }
          });
        }
      } else {
        if (_isDrowsy && _closedEyeDuration > _drowsinessThreshold) {
          // 눈을 감았다가 다시 뜨면 기록
          int additionalSleepDuration = _closedEyeDuration - _drowsinessThreshold;
          print("눈을 다시 뜨면 감긴 시간을 기록합니다: $additionalSleepDuration 초");
          CTimeStorage().addSleepDuration(Duration(seconds: additionalSleepDuration));
        }

        // 초기화
        _closedEyeDuration = 0;
        _isDrowsy = false;
        if (_drowsinessTimer != null) {
          print("타이머를 취소합니다.");
          _drowsinessTimer?.cancel();
          _drowsinessTimer = null;
        }
      }

      setState(() {
        _leftEyeRects = leftEyeRects;
        _rightEyeRects = rightEyeRects;
        isLeftEyeOpen = faces.any((face) => face.leftEyeOpenProbability! > 0.5);
        isRightEyeOpen = faces.any((face) => face.rightEyeOpenProbability! > 0.5);
      });

      print('Left Eye: ${isLeftEyeOpen ? 'Open' : 'Closed'}');
      print('Right Eye: ${isRightEyeOpen ? 'Open' : 'Closed'}');

      _faceCount = faces.length; // 감지된 얼굴 수 업데이트
      print("감지된 얼굴 수 업데이트: $_faceCount");
    } else {
      _faceCount = 0;
      _leftEyeRects = [];
      _rightEyeRects = [];
      _closedEyeDuration = 0; // 얼굴이 감지되지 않으면 시간 초기화
      _isDrowsy = false;
      print("메타데이터가 없음. _faceCount를 0으로 설정");
    }
    if (mounted) {
      setState(() {});
      print("----------------------------- 상태가 설정되었습니다.");
    }
  }

  FaceDetector get faceDetector => _faceDetector;
}
