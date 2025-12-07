/// success : true
/// message : "Attendance data fetched successfully."
/// data : {"employee_name":"Tata","checkin_time":"11:11:53","checkout_time":"11:13:57","total_work_hours":"-2 m","attendance_status":"Approved","shift":"day","action":"none"}

class AttendenceResponse {
  AttendenceResponse({
      bool? success, 
      String? message, 
      Data? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  AttendenceResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;
AttendenceResponse copyWith({  bool? success,
  String? message,
  Data? data,
}) => AttendenceResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// employee_name : "Tata"
/// checkin_time : "11:11:53"
/// checkout_time : "11:13:57"
/// total_work_hours : "-2 m"
/// attendance_status : "Approved"
/// shift : "day"
/// action : "none"

class Data {
  Data({
      String? employeeName, 
      String? checkinTime, 
      String? checkoutTime, 
      String? totalWorkHours, 
      String? attendanceStatus, 
      String? shift, 
      String? action,}){
    _employeeName = employeeName;
    _checkinTime = checkinTime;
    _checkoutTime = checkoutTime;
    _totalWorkHours = totalWorkHours;
    _attendanceStatus = attendanceStatus;
    _shift = shift;
    _action = action;
}

  Data.fromJson(Map<String, dynamic> json) {
    _employeeName = json['employee_name'];
    _checkinTime = json['checkin_time'];
    _checkoutTime = json['checkout_time'];
    _totalWorkHours = json['total_work_hours'];
    _attendanceStatus = json['attendance_status'];
    _shift = json['shift'];
    _action = json['action'];
  }
  String? _employeeName;
  String? _checkinTime;
  String? _checkoutTime;
  String? _totalWorkHours;
  String? _attendanceStatus;
  String? _shift;
  String? _action;
Data copyWith({  String? employeeName,
  String? checkinTime,
  String? checkoutTime,
  String? totalWorkHours,
  String? attendanceStatus,
  String? shift,
  String? action,
}) => Data(  employeeName: employeeName ?? _employeeName,
  checkinTime: checkinTime ?? _checkinTime,
  checkoutTime: checkoutTime ?? _checkoutTime,
  totalWorkHours: totalWorkHours ?? _totalWorkHours,
  attendanceStatus: attendanceStatus ?? _attendanceStatus,
  shift: shift ?? _shift,
  action: action ?? _action,
);
  String? get employeeName => _employeeName;
  String? get checkinTime => _checkinTime;
  String? get checkoutTime => _checkoutTime;
  String? get totalWorkHours => _totalWorkHours;
  String? get attendanceStatus => _attendanceStatus;
  String? get shift => _shift;
  String? get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employee_name'] = _employeeName;
    map['checkin_time'] = _checkinTime;
    map['checkout_time'] = _checkoutTime;
    map['total_work_hours'] = _totalWorkHours;
    map['attendance_status'] = _attendanceStatus;
    map['shift'] = _shift;
    map['action'] = _action;
    return map;
  }

}