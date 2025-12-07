part of 'home_bloc.dart';


class CheckInCheckOutSuccessState<T> extends GlobalApiResponseState<T> {
  CheckInCheckOutSuccessState({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class CategoryFetchSuccess<T> extends GlobalApiResponseState<T> {
  CategoryFetchSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}
