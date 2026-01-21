import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'face_detection_state.dart';

class FaceDetectionCubit extends Cubit<FaceDetectionState> {
  FaceDetectionCubit() : super(const FaceDetectionState());

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  List<CameraDescription> cameras = [];
  int _selectedCameraIndex = 0;

  Future<void> initialize() async {
    await _requestPermission();
    await _initializeCameras();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      debugPrint("Camera permission denied");
    }
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _selectedCameraIndex = cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

      await _initializeCamera(cameras[_selectedCameraIndex]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.yuv420,
    );

    await controller.initialize();
    emit(state.copyWith(controller: controller));
    _startFaceDetection();
  }

  void _startFaceDetection() {
    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) return;

    controller.startImageStream((image) async {
      if (state.isDetecting) return;

      emit(state.copyWith(isDetecting: true));

      final inputImage = _convertCameraImageToInputImage(image, controller);
      if (inputImage == null) {
        emit(state.copyWith(isDetecting: false));
        return;
      }

      try {
        final faces = await _faceDetector.processImage(inputImage);
        final isValid = _validateFace(faces, controller);

        emit(state.copyWith(faces: faces));

        if (isValid) {
          if (controller.value.isStreamingImages) {
            await controller.stopImageStream();
          }

          final file = await controller.takePicture();
          final bytes = await file.readAsBytes();
          emit(state.copyWith(capturedImageBytes: bytes));
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        emit(state.copyWith(isDetecting: false));
      }
    });
  }

  InputImage? _convertCameraImageToInputImage(
    CameraImage image,
    CameraController controller,
  ) {
    try {
      final format = Platform.isIOS
          ? InputImageFormat.bgra8888
          : InputImageFormat.nv21;

      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.values.firstWhere(
          (e) => e.rawValue == controller.description.sensorOrientation,
          orElse: () => InputImageRotation.rotation0deg,
        ),
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final allBytes = WriteBuffer();
      for (var plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  bool _validateFace(List<Face> faces, CameraController controller) {
    if (faces.isEmpty) return false;
    if (faces.length > 1) return false;

    final face = faces.first;
    final box = face.boundingBox;
    final previewSize = controller.value.previewSize!;
    final isFront =
        controller.description.lensDirection == CameraLensDirection.front;

    double left = box.left;
    double right = box.right;
    double top = box.top;
    double bottom = box.bottom;

    if (isFront) {
      left = previewSize.width - box.right;
      right = previewSize.width - box.left;
    }

    final faceArea = box.width * box.height;
    final imageArea = previewSize.width * previewSize.height;

    return faceArea >= imageArea * 0.05; // مثال: تحقق فقط من الحجم
  }

  Future<void> toggleCamera() async {
    final controller = state.controller;
    if (controller != null && controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }

    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    await _initializeCamera(cameras[_selectedCameraIndex]);
  }

  @override
  Future<void> close() {
    _faceDetector.close();
    state.controller?.dispose();
    return super.close();
  }
}
