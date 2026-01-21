import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/draw_face_widget.dart';

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  CameraController? _controller;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      enableContours: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  Future<void>? _initalizeControllerFuture;

  bool _isDetecating = false;
  List<Face> _faces = [];

  List<CameraDescription> cameras = [];
  int _selectedCameraIndex = 0;
  //////////////////////////////
  XFile? _capturedImage;
  String _faceError = '';
  /////////////////////////////
  @override
  void initState() {
    super.initState();
    inital();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _faceDetector.close();
  }

  Future<void> inital() async {
    await _requestPermisttion();
    await _initailzeCameras();
  }

  Future<void> _requestPermisttion() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      if (kDebugMode) {
        print("Permission denied");
      }
    }
  }

  Future<void> _initailzeCameras() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (kDebugMode) {
          print("No Cameras Found ............");
        }
        return;
      }
      _selectedCameraIndex = cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex = 0;
      }

      await _initailzeCamera(cameras[_selectedCameraIndex]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initailzeCamera(CameraDescription cameraDescription) async {
    final controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isIOS
          ? ImageFormatGroup.bgra8888
          : ImageFormatGroup.yuv420,
    );
    _controller = controller;

    _initalizeControllerFuture = controller
        .initialize()
        .then((_) {
          if (!mounted) return;

          setState(() {
            _startFaceDetecation();
          });
        })
        .catchError((onError) {
          if (kDebugMode) {
            print(onError);
          }
        });
  }

  void _startFaceDetecation() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    _controller!.startImageStream((CameraImage image) async {
      if (_isDetecating) return;

      _isDetecating = true;
      await Future.delayed(const Duration(milliseconds: 80));
      final inputImage = _convertCameraImageToInputImage(image);

      if (inputImage == null) {
        _isDetecating = false;
        return;
      }

      try {
        final List<Face> faces = await _faceDetector.processImage(inputImage);
        final isValid = _validateFace(faces);

        if (mounted) {
          setState(() {
            _faces = faces;
          });
          if (isValid) {
            // أوقف بث الكاميرا
            if (_controller!.value.isStreamingImages) {
              await _controller!.stopImageStream();
            }
            final XFile file = await _controller!.takePicture();
            setState(() {
              _capturedImage = file;
            });

            // إرسال الصورة مباشرة، بدون حفظ على الجهاز
            // sendImageToServer(file);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      } finally {
        _isDetecating = false;
      }
    });
  }

  InputImage? _convertCameraImageToInputImage(CameraImage image) {
    if (_controller == null) return null;

    try {
      final format = Platform.isIOS
          ? InputImageFormat.bgra8888
          : InputImageFormat.nv21;

      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.values.firstWhere(
          (e) => e.rawValue == _controller!.description.sensorOrientation,
          orElse: () => InputImageRotation.rotation0deg,
        ),
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      );

      final bytes = _concatonatePlanes(image.planes);
      return InputImage.fromBytes(bytes: bytes, metadata: inputImageMetadata);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Uint8List _concatonatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();

    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }

    return allBytes.done().buffer.asUint8List();
  }

  bool _validateFace(List<Face> faces) {
    if (faces.isEmpty) {
      _faceError = 'لا يوجد شخص';
      return false;
    }

    if (faces.length > 1) {
      _faceError = 'يوجد أكثر من شخص';
      return false;
    }

    final face = faces.first;
    final box = face.boundingBox;
    final previewSize = _controller!.value.previewSize!;
    final isFront =
        _controller!.description.lensDirection == CameraLensDirection.front;

    // تحويل الـ boundingBox لأبعاد الشاشة
    double left = box.left;
    double top = box.top;
    double right = box.right;
    double bottom = box.bottom;

    if (isFront) {
      // عكس محور X للكاميرا الأمامية
      left = previewSize.width - box.right;
      right = previewSize.width - box.left;
    }

    final marginX = previewSize.width * 0.0;
    final marginY = previewSize.height * 0.0;

    if (left < marginX ||
        top < marginY ||
        right > previewSize.width - marginX ||
        bottom > previewSize.height - marginY) {
      _faceError = 'اجعل حدود وجهك ظاهر بالكامل داخل الإطار';
      return false;
    }
    // فتح العينين
    final leftEye = face.leftEyeOpenProbability ?? 0;
    final rightEye = face.rightEyeOpenProbability ?? 0;

    if (leftEye < 0.6 || rightEye < 0.6) {
      _faceError = 'افتح عينيك';
      return false;
    }

    // ميلان الوجه
    if ((face.headEulerAngleY ?? 0).abs() > 15 ||
        (face.headEulerAngleZ ?? 0).abs() > 15) {
      _faceError = 'الرجاء النظر مباشرة للكاميرا';
      return false;
    }

    // حجم الوجه
    // final box = face.boundingBox;
    final faceArea = box.width * box.height;
    final imageArea =
        _controller!.value.previewSize!.width *
        _controller!.value.previewSize!.height;

    if (faceArea < imageArea * 0.05) {
      _faceError = 'اقترب من الكاميرا';
      return false;
    }

    _faceError = '';
    return true;
  }

  void _toogleCamera() async {
    if (cameras.isEmpty || cameras.length < 2) {
      print("Can not toggal camera , not camera availabe");
      return;
    }

    if (_controller != null && _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }

    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;

    setState(() {
      _capturedImage = null;
      _faces = [];
    });

    await _initailzeCamera(cameras[_selectedCameraIndex]);
  }

  void sendImageToServer(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      // هنا أرسل `bytes` للسيرفر مباشرة
      debugPrint('صورة جاهزة للإرسال، حجمها: ${bytes.length} بايت');
    } catch (e) {
      debugPrint('خطأ أثناء إرسال الصورة: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
        centerTitle: true,
        actions: [
          if (cameras.length > 1)
            IconButton(
              onPressed: _toogleCamera,
              icon: Icon(Icons.switch_camera),
            ),
        ],
      ),
      body: _initalizeControllerFuture == null
          ? Center(child: Text("No Camera Available .."))
          : FutureBuilder<void>(
              future: _initalizeControllerFuture,
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.done &&
                    _controller != null &&
                    _controller!.value.isInitialized) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _capturedImage == null
                          ? CameraPreview(_controller!)
                          : Image.file(File(_capturedImage!.path)),

                      if (_capturedImage == null)
                        DrawFaceWidget(faces: _faces, controller: _controller),

                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            if (_faceError.isNotEmpty)
                              Text(
                                _faceError,
                                style: const TextStyle(color: Colors.red),
                              ),

                            const SizedBox(height: 10),

                            if (_capturedImage != null)
                              ElevatedButton(
                                onPressed: () {
                                  sendImageToServer(_capturedImage!);
                                },
                                child: const Text('ارسال الصورة'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapShot.hasError) {
                  return Center(child: Text("Error ...."));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),

      floatingActionButton: _capturedImage != null
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _capturedImage = null;
                });
                inital();
              },
              child: Icon(Icons.replay),
            )
          : null,
    );
  }
}

// BlocProvider(
//   create: (_) => FaceDetectionCubit()..initialize(),
//   child: BlocBuilder<FaceDetectionCubit, FaceDetectionState>(
//     builder: (context, state) {
//       if (state.controller == null ||
//           !state.controller!.value.isInitialized) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       return Stack(
//         children: [
//           CameraPreview(state.controller!),

//           CustomPaint(
//             painter: FacePainter(
//               faces: state.faces,
//               imageSize: Size(
//                 state.controller!.value.previewSize!.height,
//                 state.controller!.value.previewSize!.width,
//               ),
//               cameraLensDirection:
//                   state.controller!.description.lensDirection,
//             ),
//           ),

//           if (!state.faceValid && state.error.isNotEmpty)
//             Positioned(
//               bottom: 30,
//               left: 0,
//               right: 0,
//               child: Text(
//                 state.error,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//         ],
//       );
//     },
//   ),
// );
