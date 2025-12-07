
class ResponseError {
  String? status = "";
  String? code = "";
  String? message = "";
  // List<ErrorDetails>? details =  [];

  ResponseError({
    required this.status,
    required this.code,
    required this.message,
    // required this.details,
  });

  ResponseError.fromJson(dynamic json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
   /* if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(ErrorDetails.fromJson(v));
      });
    }*/
  }



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['code'] = code;
    map['message'] = message;
   // map['details'] = details?.map((v) => v.toJson()).toList();
    return map;
  }
}

class AuthResponseError {
  final String? message;
  final bool? status;

  AuthResponseError({this.message, this.status});

  factory AuthResponseError.fromJson(Map<String, dynamic> json) {
    return AuthResponseError(
      message: json['message'] as String?,
      status: json['status'] as bool?,
    );
  }
}
