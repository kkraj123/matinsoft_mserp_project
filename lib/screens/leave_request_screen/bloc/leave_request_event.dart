part of 'leave_request_bloc.dart';

abstract class LeaveRequestEvent {
  LeaveRequestEvent();
}

class GetLeaveType extends LeaveRequestEvent{
  GetLeaveType();
}
class LeaveRequest extends LeaveRequestEvent {
  final String noOfDays;
  dynamic leaveTypeId;
  final String requestDate;
  final String fromDate;
  final String toDate;
  final String leaveReason;

  LeaveRequest({required this.noOfDays, required this.leaveTypeId, required this.requestDate, required this.fromDate, required this.toDate, required this.leaveReason});
}
class GetLeaveStatus extends LeaveRequestEvent{
  GetLeaveStatus();
}
class RemoveLeaveItem extends LeaveRequestEvent{
  dynamic leaveId;
  RemoveLeaveItem({required this.leaveId});
}
