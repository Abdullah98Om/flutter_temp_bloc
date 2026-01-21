import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionState {
  final CameraController? controller;
  final List<Face> faces;
  final bool isDetecting;
  final bool faceValid;
  final String error;
  final XFile? capturedImage;

  FaceDetectionState({
    this.controller,
    this.faces = const [],
    this.isDetecting = false,
    this.faceValid = false,
    this.error = '',
    this.capturedImage,
  });

  FaceDetectionState copyWith({
    CameraController? controller,
    List<Face>? faces,
    bool? isDetecting,
    bool? faceValid,
    String? error,
    XFile? capturedImage,
  }) {
    return FaceDetectionState(
      controller: controller ?? this.controller,
      faces: faces ?? this.faces,
      isDetecting: isDetecting ?? this.isDetecting,
      faceValid: faceValid ?? this.faceValid,
      error: error ?? this.error,
      capturedImage: capturedImage ?? this.capturedImage,
    );
  }
}
