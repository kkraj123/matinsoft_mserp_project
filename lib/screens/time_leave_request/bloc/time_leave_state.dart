part of 'time_leave_bloc.dart';


class TimeLeaveStateSuccess<T> extends GlobalApiResponseState<T>{
  TimeLeaveStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class TimeLeaveFetchSuccess<T> extends GlobalApiResponseState<T>{
  TimeLeaveFetchSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}
class TimeLeaveRemoveSuccess<T> extends GlobalApiResponseState<T>{
  TimeLeaveRemoveSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}