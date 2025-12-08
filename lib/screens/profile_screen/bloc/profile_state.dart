part of 'profile_bloc.dart';


class ProfileStateSuccess<T> extends GlobalApiResponseState<T>{
  ProfileStateSuccess({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}
class LogoutStateSuccess<T> extends GlobalApiResponseState<T>{
  LogoutStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}
