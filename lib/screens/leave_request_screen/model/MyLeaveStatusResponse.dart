/// status : "success"
/// leaves : [{"id":2,"no_of_days":1,"leave_type_id":1,"leave_requested_date":"2025-11-29T18:15:00.000000Z","leave_from":"2025-11-30T18:15:00.000000Z","leave_to":"2025-11-30T18:15:00.000000Z","status":"pending","reasons":"test","admin_remark":null,"company_id":4,"requested_by":45,"early_exit":0,"request_updated_by":null,"created_at":"2025-11-30T06:49:22.000000Z","updated_at":"2025-11-30T06:49:22.000000Z"},{"id":1,"no_of_days":2,"leave_type_id":1,"leave_requested_date":"2025-11-29T18:15:00.000000Z","leave_from":"2025-11-30T18:15:00.000000Z","leave_to":"2025-12-01T18:15:00.000000Z","status":"pending","reasons":"sick","admin_remark":null,"company_id":4,"requested_by":45,"early_exit":0,"request_updated_by":null,"created_at":"2025-11-30T06:45:34.000000Z","updated_at":"2025-11-30T06:45:34.000000Z"}]

class MyLeaveStatusResponse {
  MyLeaveStatusResponse({
      String? status, 
      List<Leaves>? leaves,}){
    _status = status;
    _leaves = leaves;
}

  MyLeaveStatusResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if (json['leaves'] != null) {
      _leaves = [];
      json['leaves'].forEach((v) {
        _leaves?.add(Leaves.fromJson(v));
      });
    }
  }
  String? _status;
  List<Leaves>? _leaves;
  MyLeaveStatusResponse copyWith({  String? status,
  List<Leaves>? leaves,
}) => MyLeaveStatusResponse(  status: status ?? _status,
  leaves: leaves ?? _leaves,
);
  String? get status => _status;
  List<Leaves>? get leaves => _leaves;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_leaves != null) {
      map['leaves'] = _leaves?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 2
/// no_of_days : 1
/// leave_type_id : 1
/// leave_requested_date : "2025-11-29T18:15:00.000000Z"
/// leave_from : "2025-11-30T18:15:00.000000Z"
/// leave_to : "2025-11-30T18:15:00.000000Z"
/// status : "pending"
/// reasons : "test"
/// admin_remark : null
/// company_id : 4
/// requested_by : 45
/// early_exit : 0
/// request_updated_by : null
/// created_at : "2025-11-30T06:49:22.000000Z"
/// updated_at : "2025-11-30T06:49:22.000000Z"

class Leaves {
  Leaves({
      num? id, 
      num? noOfDays, 
      num? leaveTypeId, 
      String? leaveRequestedDate, 
      String? leaveFrom, 
      String? leaveTo, 
      String? status, 
      String? reasons, 
      dynamic adminRemark, 
      num? companyId, 
      num? requestedBy, 
      num? earlyExit, 
      dynamic requestUpdatedBy, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _noOfDays = noOfDays;
    _leaveTypeId = leaveTypeId;
    _leaveRequestedDate = leaveRequestedDate;
    _leaveFrom = leaveFrom;
    _leaveTo = leaveTo;
    _status = status;
    _reasons = reasons;
    _adminRemark = adminRemark;
    _companyId = companyId;
    _requestedBy = requestedBy;
    _earlyExit = earlyExit;
    _requestUpdatedBy = requestUpdatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Leaves.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _noOfDays = json['no_of_days'];
    _leaveTypeId = json['leave_type_id'];
    _leaveRequestedDate = json['leave_requested_date'];
    _leaveFrom = json['leave_from'];
    _leaveTo = json['leave_to'];
    _status = json['status'];
    _reasons = json['reasons'];
    _adminRemark = json['admin_remark'];
    _companyId = json['company_id'];
    _requestedBy = json['requested_by'];
    _earlyExit = json['early_exit'];
    _requestUpdatedBy = json['request_updated_by'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _noOfDays;
  num? _leaveTypeId;
  String? _leaveRequestedDate;
  String? _leaveFrom;
  String? _leaveTo;
  String? _status;
  String? _reasons;
  dynamic _adminRemark;
  num? _companyId;
  num? _requestedBy;
  num? _earlyExit;
  dynamic _requestUpdatedBy;
  String? _createdAt;
  String? _updatedAt;
Leaves copyWith({  num? id,
  num? noOfDays,
  num? leaveTypeId,
  String? leaveRequestedDate,
  String? leaveFrom,
  String? leaveTo,
  String? status,
  String? reasons,
  dynamic adminRemark,
  num? companyId,
  num? requestedBy,
  num? earlyExit,
  dynamic requestUpdatedBy,
  String? createdAt,
  String? updatedAt,
}) => Leaves(  id: id ?? _id,
  noOfDays: noOfDays ?? _noOfDays,
  leaveTypeId: leaveTypeId ?? _leaveTypeId,
  leaveRequestedDate: leaveRequestedDate ?? _leaveRequestedDate,
  leaveFrom: leaveFrom ?? _leaveFrom,
  leaveTo: leaveTo ?? _leaveTo,
  status: status ?? _status,
  reasons: reasons ?? _reasons,
  adminRemark: adminRemark ?? _adminRemark,
  companyId: companyId ?? _companyId,
  requestedBy: requestedBy ?? _requestedBy,
  earlyExit: earlyExit ?? _earlyExit,
  requestUpdatedBy: requestUpdatedBy ?? _requestUpdatedBy,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get noOfDays => _noOfDays;
  num? get leaveTypeId => _leaveTypeId;
  String? get leaveRequestedDate => _leaveRequestedDate;
  String? get leaveFrom => _leaveFrom;
  String? get leaveTo => _leaveTo;
  String? get status => _status;
  String? get reasons => _reasons;
  dynamic get adminRemark => _adminRemark;
  num? get companyId => _companyId;
  num? get requestedBy => _requestedBy;
  num? get earlyExit => _earlyExit;
  dynamic get requestUpdatedBy => _requestUpdatedBy;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['no_of_days'] = _noOfDays;
    map['leave_type_id'] = _leaveTypeId;
    map['leave_requested_date'] = _leaveRequestedDate;
    map['leave_from'] = _leaveFrom;
    map['leave_to'] = _leaveTo;
    map['status'] = _status;
    map['reasons'] = _reasons;
    map['admin_remark'] = _adminRemark;
    map['company_id'] = _companyId;
    map['requested_by'] = _requestedBy;
    map['early_exit'] = _earlyExit;
    map['request_updated_by'] = _requestUpdatedBy;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}