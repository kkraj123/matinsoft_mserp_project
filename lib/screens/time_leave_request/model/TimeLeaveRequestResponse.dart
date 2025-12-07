/// success : true
/// message : "Time leave request submitted successfully."
/// data : {"issue_date":"2025-11-30","start_time":"01:30","end_time":"02:30","reasons":"berr","requested_by":45,"updated_at":"2025-11-30T10:15:29.000000Z","created_at":"2025-11-30T10:15:29.000000Z","id":1}

class TimeLeaveRequestResponse {
  TimeLeaveRequestResponse({
      bool? success, 
      String? message, 
      LeaveData? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  TimeLeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? LeaveData.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  LeaveData? _data;
TimeLeaveRequestResponse copyWith({  bool? success,
  String? message,
  LeaveData? data,
}) => TimeLeaveRequestResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  LeaveData? get data => _data;

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

/// issue_date : "2025-11-30"
/// start_time : "01:30"
/// end_time : "02:30"
/// reasons : "berr"
/// requested_by : 45
/// updated_at : "2025-11-30T10:15:29.000000Z"
/// created_at : "2025-11-30T10:15:29.000000Z"
/// id : 1

class LeaveData {
  LeaveData({
      String? issueDate, 
      String? startTime, 
      String? endTime, 
      String? reasons, 
      num? requestedBy, 
      String? updatedAt, 
      String? createdAt, 
      num? id,}){
    _issueDate = issueDate;
    _startTime = startTime;
    _endTime = endTime;
    _reasons = reasons;
    _requestedBy = requestedBy;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  LeaveData.fromJson(Map<String, dynamic> json) {
    _issueDate = json['issue_date'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _reasons = json['reasons'];
    _requestedBy = json['requested_by'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String? _issueDate;
  String? _startTime;
  String? _endTime;
  String? _reasons;
  num? _requestedBy;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
  LeaveData copyWith({  String? issueDate,
  String? startTime,
  String? endTime,
  String? reasons,
  num? requestedBy,
  String? updatedAt,
  String? createdAt,
  num? id,
}) => LeaveData(  issueDate: issueDate ?? _issueDate,
  startTime: startTime ?? _startTime,
  endTime: endTime ?? _endTime,
  reasons: reasons ?? _reasons,
  requestedBy: requestedBy ?? _requestedBy,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  String? get issueDate => _issueDate;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get reasons => _reasons;
  num? get requestedBy => _requestedBy;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['issue_date'] = _issueDate;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['reasons'] = _reasons;
    map['requested_by'] = _requestedBy;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}