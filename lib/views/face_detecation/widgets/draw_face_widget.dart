import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DrawFaceWidget extends StatelessWidget {
  const DrawFaceWidget({
    super.key,
    required List<Face> faces,
    required CameraController? controller,
  }) : _faces = faces,
       _controller = controller;

  final List<Face> _faces;
  final CameraController? _controller;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FacePainter(
        faces: _faces,
        imageSize: Size(
          _controller!.value.previewSize!.height,
          _controller.value.previewSize!.width,
        ),
        cameraLensDirection: _controller.description.lensDirection,
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;

  FacePainter({
    required this.faces,
    required this.imageSize,
    required this.cameraLensDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final facePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final landMarkPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    final textBackgroudPaint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.fill;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      Rect rect = face.boundingBox;

      double leftOffset = rect.left;
      double rightOffset = rect.right;
      double topOffset = rect.top;
      // double bottomOffset = rect.bottom;

      // عكس أفقي فقط للكاميرا الأمامية
      if (cameraLensDirection == CameraLensDirection.front) {
        leftOffset = imageSize.width - rightOffset;
      }
      double left = leftOffset * scaleX;
      double top = topOffset * scaleY;
      double right = (leftOffset + rect.width) * scaleX;
      double bottom = (topOffset + rect.height) * scaleY;

      final transformedRect = Rect.fromLTRB(left, top, right, bottom);

      canvas.drawRect(transformedRect, facePaint);

      void drowLandmark(FaceLandmarkType type) {
        if (face.landmarks[type] != null) {
          final point = face.landmarks[type]!.position;
          double pointX = point.x.toDouble();

          if (cameraLensDirection == CameraLensDirection.front) {
            pointX = imageSize.width - pointX;
          }
          double pointY = point.y.toDouble();

          canvas.drawCircle(
            Offset(pointX * scaleX, pointY * scaleY),
            4.0,
            landMarkPaint,
          );
        }
      }

      void drowFace(Point<int> point) {
        double pointX = point.x.toDouble();

        if (cameraLensDirection == CameraLensDirection.front) {
          pointX = imageSize.width - pointX;
        }
        double pointY = point.y.toDouble();

        canvas.drawCircle(
          Offset(pointX * scaleX, pointY * scaleY),
          2.0,
          landMarkPaint,
        );
      }

      final pp = face.contours[FaceContourType.face] != null
          ? face.contours[FaceContourType.face]!.points
          : [];
      for (var element in pp) {
        drowFace(element);
      }
      drowLandmark(FaceLandmarkType.leftEye);
      drowLandmark(FaceLandmarkType.rightEye);
      drowLandmark(FaceLandmarkType.leftMouth);
      drowLandmark(FaceLandmarkType.rightMouth);
      drowLandmark(FaceLandmarkType.noseBase);

      String mood = "Neutral";
      final smileProb = face.smilingProbability ?? 0;

      if (smileProb > 0.8) {
        mood = "Laughing";
      } else if (smileProb > 0.5) {
        mood = "Smiling";
      } else if (smileProb < 0.1) {
        mood = "Serious";
      }

      final TextSpan faceIdSpan = TextSpan(
        text: 'Face ${i + 1}\n$mood',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      final TextPainter textPainter = TextPainter(
        text: faceIdSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();

      final textRec = Rect.fromLTWH(
        left,
        top - textPainter.height - 8,
        textPainter.width + 16,
        textPainter.height + 8,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(textRec, Radius.circular(10)),
        textBackgroudPaint,
      );

      textPainter.paint(canvas, Offset(left + 8, top - textPainter.height - 4));
    }
  }

  @override
  bool shouldRepaint(covariant FacePainter oldDelegate) =>
      oldDelegate.faces != faces;
}
