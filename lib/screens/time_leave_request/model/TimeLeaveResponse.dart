/// success : true
/// message : "Time leave requests fetched successfully."
/// data : [{"id":1,"issue_date":"2025-11-30","start_time":"01:30:00","end_time":"02:30:00","status":"pending","reasons":"berr","admin_remark":null,"requested_by":45,"created_at":"2025-11-30T10:15:29.000000Z","updated_at":"2025-11-30T10:15:29.000000Z"},{"id":2,"issue_date":"2025-11-30","start_time":"19:54:00","end_time":"23:20:00","status":"pending","reasons":"tedt","admin_remark":null,"requested_by":45,"created_at":"2025-11-30T11:09:32.000000Z","updated_at":"2025-11-30T11:09:32.000000Z"},{"id":3,"issue_date":"2025-11-30","start_time":"19:01:00","end_time":"23:02:00","status":"pending","reasons":"tuuyu","admin_remark":null,"requested_by":45,"created_at":"2025-11-30T11:17:08.000000Z","updated_at":"2025-11-30T11:17:08.000000Z"}]

class TimeLeaveResponse {
  TimeLeaveResponse({
      bool? success, 
      String? message, 
      List<TimeLeaveData>? data,}){
    _success = success;
    _message = message;
    _data = data;
}

  TimeLeaveResponse.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(TimeLeaveData.fromJson(v));
      });
    }
  }
  bool? _success;
  String? _message;
  List<TimeLeaveData>? _data;
TimeLeaveResponse copyWith({  bool? success,
  String? message,
  List<TimeLeaveData>? data,
}) => TimeLeaveResponse(  success: success ?? _success,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get success => _success;
  String? get message => _message;
  List<TimeLeaveData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// issue_date : "2025-11-30"
/// start_time : "01:30:00"
/// end_time : "02:30:00"
/// status : "pending"
/// reasons : "berr"
/// admin_remark : null
/// requested_by : 45
/// created_at : "2025-11-30T10:15:29.000000Z"
/// updated_at : "2025-11-30T10:15:29.000000Z"

class TimeLeaveData {
  TimeLeaveData({
      num? id, 
      String? issueDate, 
      String? startTime, 
      String? endTime, 
      String? status, 
      String? reasons, 
      dynamic adminRemark, 
      num? requestedBy, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _issueDate = issueDate;
    _startTime = startTime;
    _endTime = endTime;
    _status = status;
    _reasons = reasons;
    _adminRemark = adminRemark;
    _requestedBy = requestedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  TimeLeaveData.fromJson(dynamic json) {
    _id = json['id'];
    _issueDate = json['issue_date'];
    _startTime = json['start_time'];
    _endTime = json['end_time'];
    _status = json['status'];
    _reasons = json['reasons'];
    _adminRemark = json['admin_remark'];
    _requestedBy = json['requested_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _issueDate;
  String? _startTime;
  String? _endTime;
  String? _status;
  String? _reasons;
  dynamic _adminRemark;
  num? _requestedBy;
  String? _createdAt;
  String? _updatedAt;
  TimeLeaveData copyWith({  num? id,
  String? issueDate,
  String? startTime,
  String? endTime,
  String? status,
  String? reasons,
  dynamic adminRemark,
  num? requestedBy,
  String? createdAt,
  String? updatedAt,
}) => TimeLeaveData(  id: id ?? _id,
  issueDate: issueDate ?? _issueDate,
  startTime: startTime ?? _startTime,
  endTime: endTime ?? _endTime,
  status: status ?? _status,
  reasons: reasons ?? _reasons,
  adminRemark: adminRemark ?? _adminRemark,
  requestedBy: requestedBy ?? _requestedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get issueDate => _issueDate;
  String? get startTime => _startTime;
  String? get endTime => _endTime;
  String? get status => _status;
  String? get reasons => _reasons;
  dynamic get adminRemark => _adminRemark;
  num? get requestedBy => _requestedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['issue_date'] = _issueDate;
    map['start_time'] = _startTime;
    map['end_time'] = _endTime;
    map['status'] = _status;
    map['reasons'] = _reasons;
    map['admin_remark'] = _adminRemark;
    map['requested_by'] = _requestedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}