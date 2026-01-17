class TimeoutException implements Exception {
  final String message = 'Connection timeout';
}

class NoInternetException implements Exception {
  final String message = 'No internet connection';
}

class RequestCancelledException implements Exception {
  final String message = 'Request cancelled';
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

class UnauthorizedException implements Exception {
  final String message = 'Unauthorized access';
}

class ForbiddenException implements Exception {
  final String message = 'Access forbidden';
}

class NotFoundException implements Exception {
  final String message = 'Resource not found';
}

class ConflictException implements Exception {
  final String message = 'Conflict occurred';
}

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Internal server error']);
}

class UnknownException implements Exception {
  final String message = 'An unknown error occurred';
}
