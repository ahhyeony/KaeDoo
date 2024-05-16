import 'dart:typed_data';

class CameraImage {
  final Uint8List imageData;
  final DateTime timestamp;
  CameraImage({required this.imageData, required this.timestamp});
}