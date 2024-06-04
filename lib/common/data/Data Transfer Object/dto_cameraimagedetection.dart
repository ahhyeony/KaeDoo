import 'dart:typed_data';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:kaedoo/common/data/cameraimage.dart' as custom;
import 'package:kaedoo/common/widget/w_face_detector.dart';

class CameraImageDetection {
  final CameraController _cameraController;
  final GlobalKey<FaceDetectionState> faceDetectionKey;
  bool _isDetecting = false;
  Timer? timer;
  CameraImage? latestImage;

  CameraImageDetection(this._cameraController, this.faceDetectionKey);

  void startDetection() {
    if (!_cameraController.value.isInitialized) {
      return;
    }
    _isDetecting = true;

    _cameraController.startImageStream((CameraImage cameraImage) {
      if (_isDetecting) {
        latestImage = cameraImage;
      }
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (latestImage != null) {
        await _processImage(latestImage!);
      }
    });
  }

  Future<void> _processImage(CameraImage cameraImage) async {
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

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(width.toDouble(), height.toDouble()),
          rotation: imageRotation,
          format: InputImageFormat.nv21,
          bytesPerRow: cameraImage.planes[0].bytesPerRow,
        ),
      );

      await faceDetectionKey.currentState?.processImage(inputImage);
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  void stopDetection() {
    _isDetecting = false;
    if (_cameraController.value.isStreamingImages) {
      _cameraController.stopImageStream();
      print('Image detection stopped');
    }
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

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
