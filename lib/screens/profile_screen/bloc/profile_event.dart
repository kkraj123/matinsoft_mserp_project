part of 'profile_bloc.dart';


abstract class ProfileEvent {
  ProfileEvent();
}

class GetProfile extends ProfileEvent{
  GetProfile();
}
class Logout extends ProfileEvent{
  Logout();
}