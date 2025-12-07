part of 'leave_request_bloc.dart';


class LeaveTypeStateSuccess<T> extends GlobalApiResponseState<T>{
  LeaveTypeStateSuccess({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class LeaveRequestStateSuccess<T> extends GlobalApiResponseState<T>{
  LeaveRequestStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class LeaveRequestStatusStateSuccess<T> extends GlobalApiResponseState<T>{
  LeaveRequestStatusStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class LeaveRemoveStateSuccess<T> extends GlobalApiResponseState<T>{
  LeaveRemoveStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}
