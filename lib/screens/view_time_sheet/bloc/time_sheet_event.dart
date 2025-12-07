part of 'time_sheet_bloc.dart';

abstract class TimeSheetEvent {
  TimeSheetEvent();
}

class AttendanceEvent extends TimeSheetEvent{
  AttendanceEvent();
}
