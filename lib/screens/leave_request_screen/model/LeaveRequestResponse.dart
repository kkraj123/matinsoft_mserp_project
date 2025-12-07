/// status : "success"
/// message : "Leave request submitted successfully"
/// leave : {"no_of_days":"2","leave_type_id":"1","leave_requested_date":"2025-11-29T18:15:00.000000Z","leave_from":"2025-11-30T18:15:00.000000Z","leave_to":"2025-12-02T18:15:00.000000Z","status":"pending","reasons":"sick","company_id":4,"requested_by":45,"early_exit":0,"updated_at":"2025-11-30T06:09:18.000000Z","created_at":"2025-11-30T06:09:18.000000Z","id":2}

class LeaveRequestResponse {
  LeaveRequestResponse({
      String? status, 
      String? message, 
      Leave? leave,}){
    _status = status;
    _message = message;
    _leave = leave;
}

  LeaveRequestResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _leave = json['leave'] != null ? Leave.fromJson(json['leave']) : null;
  }
  String? _status;
  String? _message;
  Leave? _leave;
LeaveRequestResponse copyWith({  String? status,
  String? message,
  Leave? leave,
}) => LeaveRequestResponse(  status: status ?? _status,
  message: message ?? _message,
  leave: leave ?? _leave,
);
  String? get status => _status;
  String? get message => _message;
  Leave? get leave => _leave;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_leave != null) {
      map['leave'] = _leave?.toJson();
    }
    return map;
  }

}

/// no_of_days : "2"
/// leave_type_id : "1"
/// leave_requested_date : "2025-11-29T18:15:00.000000Z"
/// leave_from : "2025-11-30T18:15:00.000000Z"
/// leave_to : "2025-12-02T18:15:00.000000Z"
/// status : "pending"
/// reasons : "sick"
/// company_id : 4
/// requested_by : 45
/// early_exit : 0
/// updated_at : "2025-11-30T06:09:18.000000Z"
/// created_at : "2025-11-30T06:09:18.000000Z"
/// id : 2

class Leave {
  Leave({
      String? noOfDays, 
      String? leaveTypeId, 
      String? leaveRequestedDate, 
      String? leaveFrom, 
      String? leaveTo, 
      String? status, 
      String? reasons, 
      num? companyId, 
      num? requestedBy, 
      num? earlyExit, 
      String? updatedAt, 
      String? createdAt, 
      num? id,}){
    _noOfDays = noOfDays;
    _leaveTypeId = leaveTypeId;
    _leaveRequestedDate = leaveRequestedDate;
    _leaveFrom = leaveFrom;
    _leaveTo = leaveTo;
    _status = status;
    _reasons = reasons;
    _companyId = companyId;
    _requestedBy = requestedBy;
    _earlyExit = earlyExit;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
}

  Leave.fromJson(Map<String, dynamic> json) {
    _noOfDays = json['no_of_days'];
    _leaveTypeId = json['leave_type_id'];
    _leaveRequestedDate = json['leave_requested_date'];
    _leaveFrom = json['leave_from'];
    _leaveTo = json['leave_to'];
    _status = json['status'];
    _reasons = json['reasons'];
    _companyId = json['company_id'];
    _requestedBy = json['requested_by'];
    _earlyExit = json['early_exit'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
  }
  String? _noOfDays;
  String? _leaveTypeId;
  String? _leaveRequestedDate;
  String? _leaveFrom;
  String? _leaveTo;
  String? _status;
  String? _reasons;
  num? _companyId;
  num? _requestedBy;
  num? _earlyExit;
  String? _updatedAt;
  String? _createdAt;
  num? _id;
Leave copyWith({  String? noOfDays,
  String? leaveTypeId,
  String? leaveRequestedDate,
  String? leaveFrom,
  String? leaveTo,
  String? status,
  String? reasons,
  num? companyId,
  num? requestedBy,
  num? earlyExit,
  String? updatedAt,
  String? createdAt,
  num? id,
}) => Leave(  noOfDays: noOfDays ?? _noOfDays,
  leaveTypeId: leaveTypeId ?? _leaveTypeId,
  leaveRequestedDate: leaveRequestedDate ?? _leaveRequestedDate,
  leaveFrom: leaveFrom ?? _leaveFrom,
  leaveTo: leaveTo ?? _leaveTo,
  status: status ?? _status,
  reasons: reasons ?? _reasons,
  companyId: companyId ?? _companyId,
  requestedBy: requestedBy ?? _requestedBy,
  earlyExit: earlyExit ?? _earlyExit,
  updatedAt: updatedAt ?? _updatedAt,
  createdAt: createdAt ?? _createdAt,
  id: id ?? _id,
);
  String? get noOfDays => _noOfDays;
  String? get leaveTypeId => _leaveTypeId;
  String? get leaveRequestedDate => _leaveRequestedDate;
  String? get leaveFrom => _leaveFrom;
  String? get leaveTo => _leaveTo;
  String? get status => _status;
  String? get reasons => _reasons;
  num? get companyId => _companyId;
  num? get requestedBy => _requestedBy;
  num? get earlyExit => _earlyExit;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['no_of_days'] = _noOfDays;
    map['leave_type_id'] = _leaveTypeId;
    map['leave_requested_date'] = _leaveRequestedDate;
    map['leave_from'] = _leaveFrom;
    map['leave_to'] = _leaveTo;
    map['status'] = _status;
    map['reasons'] = _reasons;
    map['company_id'] = _companyId;
    map['requested_by'] = _requestedBy;
    map['early_exit'] = _earlyExit;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    return map;
  }

}