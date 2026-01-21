import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_temp_bloc/viewmodels/face_detection_cubit/face_detection_state.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceDetectionCubit extends Cubit<FaceDetectionState> {
  FaceDetectionCubit() : super(FaceDetectionState());

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    ),
  );

  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  bool _saving = false;

  Future<void> initialize() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      emit(state.copyWith(error: 'تم رفض صلاحية الكاميرا'));
      return;
    }

    cameras = await availableCameras();
    selectedCameraIndex = cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
    );
    if (selectedCameraIndex == -1) selectedCameraIndex = 0;

    final controller = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.yuv420,
    );

    await controller.initialize();
    emit(state.copyWith(controller: controller));

    controller.startImageStream(processImage);
  }

  Future<void> processImage(CameraImage image) async {
    if (state.isDetecting || state.controller == null) return;

    emit(state.copyWith(isDetecting: true));

    final inputImage = _convert(image);
    if (inputImage == null) {
      emit(state.copyWith(isDetecting: false));
      return;
    }

    final faces = await _faceDetector.processImage(inputImage);
    final isValid = _validateFace(faces);

    emit(state.copyWith(faces: faces, faceValid: isValid, isDetecting: false));

    if (isValid) {
      await _autoSave();
    }
  }

  InputImage? _convert(CameraImage image) {
    final controller = state.controller;
    if (controller == null) return null;

    try {
      final InputImageFormat format = Platform.isIOS
          ? InputImageFormat.bgra8888
          : InputImageFormat.nv21;

      final rotation = InputImageRotation.values.firstWhere(
        (e) => e.rawValue == controller.description.sensorOrientation,
        orElse: () => InputImageRotation.rotation0deg,
      );

      final metadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final bytes = _concatenatePlanes(image.planes);

      return InputImage.fromBytes(bytes: bytes, metadata: metadata);
    } catch (e) {
      debugPrint('❌ Convert error: $e');
      return null;
    }
  }

  Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();

    for (final Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }

    return allBytes.done().buffer.asUint8List();
  }

  bool _validateFace(List<Face> faces) {
    if (faces.length != 1) return false;

    final face = faces.first;

    if ((face.leftEyeOpenProbability ?? 0) < 0.5) return false;
    if ((face.rightEyeOpenProbability ?? 0) < 0.5) return false;

    if ((face.headEulerAngleY ?? 0).abs() > 15) return false;

    return true;
  }

  Future<void> _autoSave() async {
    if (_saving || state.controller == null) return;
    _saving = true;

    await state.controller!.stopImageStream();

    final file = await state.controller!.takePicture();
    final dir = await getApplicationDocumentsDirectory();

    final savedPath =
        '${dir.path}/face_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedFile = await File(file.path).copy(savedPath);

    emit(state.copyWith(capturedImage: XFile(savedFile.path)));
  }
}
