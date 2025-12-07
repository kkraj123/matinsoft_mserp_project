
class OAuthError {
  OAuthError({
    required this.error,
    required this.errorDescription,
  });

  OAuthError.fromJson(dynamic json) {
    error = json['error'];
    errorDescription = json['error_description'];
  }

  String error = "";
  String errorDescription = "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['error_description'] = errorDescription;
    return map;
  }
}
