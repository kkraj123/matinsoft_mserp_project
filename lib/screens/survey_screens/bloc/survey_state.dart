part of 'survey_bloc.dart';


class SurveyListStateSuccess<T> extends GlobalApiResponseState<T>{
  SurveyListStateSuccess({
    T? data,
    String message = ''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class SurveyAnswerStateSuccess<T> extends GlobalApiResponseState<T>{
  SurveyAnswerStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class SurveyResponseListStateSuccess<T> extends GlobalApiResponseState<T>{
  SurveyResponseListStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}

class ResponseDetailsStateSuccess<T> extends GlobalApiResponseState<T>{
  ResponseDetailsStateSuccess({
    T? data,
    String message = ''
  }): super(status: GlobalApiStatus.completed, message: message, data: data);
}
class UpdateResponseDetailSuccess<T> extends GlobalApiResponseState<T>{
  UpdateResponseDetailSuccess({
    T? data,
    String message =''
}): super(status: GlobalApiStatus.completed, message: message, data: data);
}