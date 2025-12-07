part of 'login_bloc.dart';

class LoginSuccessStates<T> extends GlobalApiResponseState<T>{
  LoginSuccessStates({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}
