import 'package:dio/dio.dart';
import 'dart:io';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_temp_bloc/core/api/dio_client.dart';
import 'package:flutter_temp_bloc/core/api/end_points.dart';

class MyService {
  final ApiClient apiClient;

  MyService(this.apiClient);

  // مثال لإرسال صورة لتسجيل الوجه لأول مرة
  Future<Either<String, dynamic>> enrollFace({
    required File imageFile,
    required String device,
    required String deviceId,
  }) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
      'device': device,
      'deviceId': deviceId,
    });

    try {
      final response = await apiClient.postFile(
        EndPoints.refreshToken,
        formData,
        requiresAuth: true, // لأن هذه العملية تتطلب Access Token
      );
      return right(response);
    } catch (e) {
      return left(e.toString());
    }
  }
}
