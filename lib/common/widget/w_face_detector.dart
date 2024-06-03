import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'w_face_painter.dart';

class FaceDetection extends StatefulWidget {
  const FaceDetection({Key? key}) : super(key: key);

  @override
  State<FaceDetection> createState() => FaceDetectionState();
}

class FaceDetectionState extends State<FaceDetection> {
  late final FaceDetector _faceDetector;
  bool _canProcess = true;
  CustomPaint? _customPaint;
  int _faceCount = 0;

  // 눈 검출
  bool isLeftEyeOpen = false;
  bool isRightEyeOpen = false;
  List<Rect> _leftEyeRects = [];
  List<Rect> _rightEyeRects = [];

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
        )
    );
    print("FaceDetector 초기화 완료");
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    print("FaceDetector disposed.");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("FaceDetection build 호출됨. 감지된 얼굴 수: $_faceCount");
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
          child: _customPaint,
        ),
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
                  fontWeight: FontWeight.bold,)
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
              ]
          )
        ),
      ],
    );
  }

  Future<void> processImage(final InputImage inputImage) async {

    print("processImage 메서드가 호출되었습니다.");
    // 작업 못 하는 경우
    if (!_canProcess){
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

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {

      //eye detection
      List<Rect> leftEyeRects = [];
      List<Rect> rightEyeRects = [];

      for (Face face in faces) {
        if (face.leftEyeOpenProbability != null && face.rightEyeOpenProbability != null) {
          print('Left Eye Open Probability: ${face.leftEyeOpenProbability}');
          print('Right Eye Open Probability: ${face.rightEyeOpenProbability}');

          setState(() {
            isLeftEyeOpen = face.leftEyeOpenProbability! > 0.5;
            isRightEyeOpen = face.rightEyeOpenProbability! > 0.5;
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

      setState(() {
        _leftEyeRects = leftEyeRects;
        _rightEyeRects = rightEyeRects;
        isLeftEyeOpen = faces.any((face) => face.leftEyeOpenProbability! > 0.5);
        isRightEyeOpen = faces.any((face) => face.rightEyeOpenProbability! > 0.5);
      });

      print('Left Eye: ${isLeftEyeOpen ? 'Open' : 'Closed'}');
      print('Right Eye: ${isRightEyeOpen ? 'Open' : 'Closed'}');

      // painter
      final painter = FaceDetectorPainter(
          faces,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation);
      _customPaint = CustomPaint(painter: painter);

      _faceCount = faces.length; // 감지된 얼굴 수 업데이트
      print("페인터가 생성되었습니다. 감지된 얼굴 수 업데이트: $_faceCount");
    }
    else {
      _customPaint = null;
      _faceCount = 0;
      _leftEyeRects = [];
      _rightEyeRects = [];
      print("메타데이터가 없음. _faceCount를 0으로 설정");
    }
    if (mounted) {
      setState(() {});
      print("----------------------------- 상태가 설정되었습니다.");
    }
  }
  FaceDetector get faceDetector => _faceDetector;
}