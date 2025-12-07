part of 'time_sheet_bloc.dart';


class AttendanceStateSuccess<T> extends GlobalApiResponseState<T>{
  AttendanceStateSuccess({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}
