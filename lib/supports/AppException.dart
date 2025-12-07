class AppException implements Exception {
  final String message;

  AppException(this.message);

  String toString() {
    return "$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message = ""]) : super(message);
}

//used for invalid login request
class BadRequestException extends AppException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message);
}

class AccessTokenExpiredException extends AppException {
  AccessTokenExpiredException([message]) : super(message);
}

class ApiTimeoutException extends AppException {
  ApiTimeoutException([message]) : super(message);
}

class InternalServerException extends AppException {
  InternalServerException([String message = ""]) : super(message);
}

class InvalidInputException extends AppException {
  InvalidInputException([String message = ""]) : super(message);
}
