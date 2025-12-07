/// long_message : {}
/// message : "App\\Controller\\SubPlansController:create is not resolvable"
/// class : "RuntimeException"
/// status : "error"
/// code : 500

class ErrorResponse {
  ErrorResponse({
      dynamic longMessage, 
      String? message, 
      String? excepion,
      String? status, 
      num? code,}){
    _longMessage = longMessage;
    _message = message;
    _excepion = excepion;
    _status = status;
    _code = code;
}

  ErrorResponse.fromJson(dynamic json) {
    _longMessage = json['long_message'];
    _message = json['message'];
    _excepion = json['class'];
    _status = json['status'];
    _code = json['code'];
  }
  dynamic _longMessage;
  String? _message;
  String? _excepion;
  String? _status;
  num? _code;
ErrorResponse copyWith({  dynamic longMessage,
  String? message,
  String? excepion,
  String? status,
  num? code,
}) => ErrorResponse(  longMessage: longMessage ?? _longMessage,
  message: message ?? _message,
  excepion: excepion ?? _excepion,
  status: status ?? _status,
  code: code ?? _code,
);
  dynamic get longMessage => _longMessage;
  String? get message => _message;
  String? get excepion => _excepion;
  String? get status => _status;
  num? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['long_message'] = _longMessage;
    map['message'] = _message;
    map['class'] = _excepion;
    map['status'] = _status;
    map['code'] = _code;
    return map;
  }

}