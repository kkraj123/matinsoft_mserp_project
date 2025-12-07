part of 'home_bloc.dart';

abstract class HomeEvent {
  HomeEvent();
}

class CheckInCheckOutPost extends HomeEvent{
  String bssid;
  String code;
  String type;

  CheckInCheckOutPost({required this.bssid, required this.code, required this.type});
}
class CategoryFetch extends HomeEvent{
  CategoryFetch();
}
