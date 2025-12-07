part of 'time_leave_bloc.dart';

abstract class TimeLeaveEvent {
  TimeLeaveEvent();
}

class TimeLeaveRequest extends TimeLeaveEvent{
  final String issueDate;
  final String startTime;
  final String endTime;
  final String reason;

  TimeLeaveRequest({required this.issueDate,required this.startTime,required this.endTime,required this.reason});
}
class TimeLeaveFetch extends TimeLeaveEvent{
  TimeLeaveFetch();
}
class DeleteTimeLeave extends TimeLeaveEvent{
  dynamic leaveTimeId;
  DeleteTimeLeave({required this.leaveTimeId});
}