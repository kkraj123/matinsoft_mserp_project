


import 'package:mserp/supports/AppException.dart';

enum GlobalApiStatus { loading, completed, error, initial }

abstract class GlobalApiResponseState<T> {
  final GlobalApiStatus status;
  final String message;
  final AppException? exception;
  final T? data;

  const GlobalApiResponseState({
    required this.status,
    this.message = '',
    this.exception,
    this.data,
  });
}

class InitialState extends GlobalApiResponseState<void> {
  const InitialState() : super(status: GlobalApiStatus.initial);
}

class ApiLoadingState<T> extends GlobalApiResponseState<T> {
  const ApiLoadingState({String message = 'Loading...'})
      : super(status: GlobalApiStatus.loading, message: message);
}

class ApiErrorState extends GlobalApiResponseState<void> {
  ApiErrorState({AppException? exception})
      : super(
          status: GlobalApiStatus.error,
          message: exception?.message ?? 'Error! Please try again.',
          exception: exception ?? AppException('Error! Please try again.'),
        );
}
