part of 'survey_bloc.dart';


abstract class SurveyEvent {
  SurveyEvent();
}
class GetSurveyList extends SurveyEvent{
  dynamic pageCount;
  GetSurveyList({required this.pageCount});
}
class PostSurveyResponse extends SurveyEvent{
  dynamic surveyId;
  final List<Map<String, dynamic>> answerBody;
  final Map<int, String>? filePaths;
  PostSurveyResponse({required this.surveyId ,required this.answerBody, this.filePaths});
}
class UpdateSurveyResponse extends SurveyEvent{
  dynamic responseId;
  dynamic surveyId;
  final List<Map<String, dynamic>> updateAnswers;
  final Map<int, String>? filePaths;
  UpdateSurveyResponse({required this.surveyId ,required this.updateAnswers, this.filePaths, required this.responseId});
}
class GetSurveyResponseList extends SurveyEvent{
  dynamic surveyId;
  dynamic pageCount;
  GetSurveyResponseList({required this.surveyId,required this.pageCount});
}
class FetchResponseDetails extends SurveyEvent{
  dynamic userId;
  FetchResponseDetails({required this.userId});
}