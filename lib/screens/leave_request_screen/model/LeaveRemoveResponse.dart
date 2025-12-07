/// status : "success"
/// message : "Leave request deleted successfully"

class LeaveRemoveResponse {
  LeaveRemoveResponse({
      String? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  LeaveRemoveResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
  }
  String? _status;
  String? _message;
LeaveRemoveResponse copyWith({  String? status,
  String? message,
}) => LeaveRemoveResponse(  status: status ?? _status,
  message: message ?? _message,
);
  String? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}