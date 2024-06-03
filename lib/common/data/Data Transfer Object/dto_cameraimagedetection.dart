import 'dart:typed_data';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kaedoo/common/data/cameraimage.dart' as custom;
import 'package:kaedoo/common/widget/w_face_detector.dart';

class CameraImageDetection {
  final CameraController _cameraController;
  final GlobalKey<FaceDetectionState> faceDetectionKey;
  List<custom.CameraImage> _capturedImages = [];
  bool _isDetecting = false;
  int _frameCounter = 0;

  CameraImageDetection(this._cameraController, this.faceDetectionKey);

  void startDetection() {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    _isDetecting = true;

    _cameraController.startImageStream((CameraImage cameraImage) async {
      _frameCounter++;
      if (!_isDetecting || _frameCounter % 10 != 0) {
        return;
      }
      _frameCounter = 0;

      try {
        final int width = cameraImage.width;
        final int height = cameraImage.height;
        final int rotation = _cameraController.description.sensorOrientation;
        final InputImageRotation imageRotation = _getInputImageRotation(rotation);

        final WriteBuffer allBytes = WriteBuffer();
        for (Plane plane in cameraImage.planes) {
          allBytes.putUint8List(plane.bytes);
        }
        final Uint8List bytes = allBytes.done().buffer.asUint8List();

        // 이미지 회전을 반영한 크기 계산
        final int adjustedWidth = (imageRotation == InputImageRotation.rotation90deg || imageRotation == InputImageRotation.rotation270deg) ? height : width;
        final int adjustedHeight = (imageRotation == InputImageRotation.rotation90deg || imageRotation == InputImageRotation.rotation270deg) ? width : height;

        // 이미지 방향 확인을 위한 로그 추가
        final String orientation = adjustedWidth > adjustedHeight ? "가로" : "세로";
        print("이미지 방향: $orientation");
        print("조정된 이미지 너비: $adjustedWidth");
        print("조정된 이미지 높이: $adjustedHeight");
        print("이미지 회전: $rotation");
        print("바이트 길이: ${bytes.length}");
        print("첫 10 바이트: ${bytes.sublist(0, 10)}");

        //final inputImage = InputImage.fromFilePath('얼굴.PNG');
        final inputImage = InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(width.toDouble(), height.toDouble()),
            rotation: imageRotation,
            format: InputImageFormat.nv21,
            //format: InputImageFormat.yuv_420_888, // 일반적인 YUV 포맷
            bytesPerRow: cameraImage.planes[0].bytesPerRow~/2,
          ),
        );

        print("이미지 메타데이터: ${inputImage.metadata}");
        print("이미지 바이트 길이: ${inputImage.bytes?.length}");

        print("지금 호출한다?");
        await faceDetectionKey.currentState?.processImage(inputImage);
        print("processImage 호출 완료");

        if (_capturedImages.length >= 3) {
          _capturedImages.clear();
          print('Image list cleared at ${DateTime.now()}');
        }
      } catch (e) {
        print('Error processing image: $e');
      }
    });
  }

  void stopDetection() {
    _isDetecting = false;
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
      print('Image detection stopped');
    }
  }

  List<custom.CameraImage> get capturedImages => _capturedImages;

  InputImageRotation _getInputImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }
}