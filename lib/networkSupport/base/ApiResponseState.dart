

import 'package:mserp/supports/AppException.dart';

enum Status { loading, completed, error, initial }

class ApiResponseState<T> {
  Status status;
  T? data;
  String message = "";
  AppException exception = AppException("Error! Please try again");

  ApiResponseState.loading(this.message) : status = Status.loading;

  ApiResponseState.completed(this.data) : status = Status.completed;

  ApiResponseState.error(this.exception) : status = Status.error;
}