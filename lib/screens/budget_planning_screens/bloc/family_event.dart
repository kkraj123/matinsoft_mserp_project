part of 'family_bloc.dart';

abstract class FamilyEvent {
  FamilyEvent();
}

class GetFamilyDashboard extends FamilyEvent{
  dynamic userId;
  GetFamilyDashboard({required this.userId});
}