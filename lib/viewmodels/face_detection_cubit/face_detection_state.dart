import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionState extends Equatable {
  final CameraController? controller;
  final List<Face> faces;
  final Uint8List? capturedImageBytes; // الصورة في الذاكرة
  final String faceError;
  final bool isDetecting;

  const FaceDetectionState({
    this.controller,
    this.faces = const [],
    this.capturedImageBytes,
    this.faceError = '',
    this.isDetecting = false,
  });

  FaceDetectionState copyWith({
    CameraController? controller,
    List<Face>? faces,
    Uint8List? capturedImageBytes,
    String? faceError,
    bool? isDetecting,
  }) {
    return FaceDetectionState(
      controller: controller ?? this.controller,
      faces: faces ?? this.faces,
      capturedImageBytes: capturedImageBytes ?? this.capturedImageBytes,
      faceError: faceError ?? this.faceError,
      isDetecting: isDetecting ?? this.isDetecting,
    );
  }

  @override
  List<Object?> get props => [
    controller,
    faces,
    capturedImageBytes,
    faceError,
    isDetecting,
  ];
}
