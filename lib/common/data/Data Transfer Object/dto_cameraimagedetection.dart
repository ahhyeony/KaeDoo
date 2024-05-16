import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:kaedoo/common/data/cameraimage.dart' as custom;

class CameraImageDetection {
  final CameraController _cameraController;
  List<custom.CameraImage> _capturedImages = [];
  bool _isDetecting = false;

  CameraImageDetection(this._cameraController);

  Future<void> startDetection() async {
    if (!_cameraController.value.isInitialized) {
      return;
    }

    _isDetecting = true;

    while (_isDetecting) {
      await Future.delayed(Duration(seconds: 10));
      if (!_cameraController.value.isInitialized || !_isDetecting) {
        break;
      }

      try {
        final XFile imageFile = await _cameraController.takePicture();
        final Uint8List imageData = await imageFile.readAsBytes();
        final DateTime timestamp = DateTime.now();

        _capturedImages.add(custom.CameraImage(imageData: imageData, timestamp: timestamp));
        print('Image captured at $timestamp');

        // 30초마다 이미지 리스트 초기화
        if (_capturedImages.length >= 3) {
          _capturedImages.clear();
          print('Image list cleared at $timestamp');
        }
      } catch (e) {
        print('Error capturing image: $e');
      }
    }
  }

  void stopDetection() {
    _isDetecting = false;
    print('Image detection stopped');
  }

  List<custom.CameraImage> get capturedImages => _capturedImages;
}
