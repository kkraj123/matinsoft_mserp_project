part of 'family_bloc.dart';


class FamilyDashboardStateSuccess<T> extends GlobalApiResponseState<T>{
  FamilyDashboardStateSuccess({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}
