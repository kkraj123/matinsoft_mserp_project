class AuthError{
  final String? message;
  final bool? status;

  AuthError({this.message, this.status});

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(
      message: json['message'] as String?,
      status: json['status'] as bool?,
    );
  }
}