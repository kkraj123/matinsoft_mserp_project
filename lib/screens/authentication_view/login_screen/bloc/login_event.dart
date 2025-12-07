part of 'login_bloc.dart';

abstract class LoginEvent {
  LoginEvent();
}

class PostLogin extends LoginEvent {
  final String email;
  final String password;
  PostLogin({required this.email, required this.password});
}