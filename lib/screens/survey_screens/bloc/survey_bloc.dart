import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/GlobalApiResponseState.dart';
import 'package:mserp/screens/survey_screens/model/ResponseDetailsModel.dart';
import 'package:mserp/screens/survey_screens/model/SurveyListResponse.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseList.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseModel.dart';
import 'package:mserp/screens/survey_screens/survey_repo/survey_repository.dart';
import 'package:mserp/supports/AppException.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, GlobalApiResponseState> {
  final SurveyRepository surveyRepository;

  SurveyBloc({required this.surveyRepository}) : super(const InitialState()) {
    on<GetSurveyList>(getSurveyList);
    on<PostSurveyResponse>(postSurveyResponse);
    on<GetSurveyResponseList>(getSurveyResponseList);
    on<FetchResponseDetails>(fetchResponseDetails);
    on<UpdateSurveyResponse>(updateSurveyResponse);
  }
  getSurveyList(SurveyEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is GetSurveyList){
      emit(const ApiLoadingState());
      final params = {
        'page' : event.pageCount
      };
      try {
        ApiResult<SurveyListResponse> surveyListResponse = await surveyRepository.getSurveyList(params);
        surveyListResponse.when(
          success: (SurveyListResponse categoryItems) async {
            emit(SurveyListStateSuccess(data: categoryItems));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }
  postSurveyResponse(SurveyEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is PostSurveyResponse){
      emit(const ApiLoadingState());
      final answerBody = {
          'survey_id': event.surveyId,
          'answers' : event.answerBody
      };
      try {
        ApiResult<SurveyResponseModel> surveyResponse = await surveyRepository.answerSurveyResponse(answerBody, event.filePaths);
        surveyResponse.when(
          success: (SurveyResponseModel surveyAnswer) async {
            emit(SurveyAnswerStateSuccess(data: surveyAnswer));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }

  updateSurveyResponse(SurveyEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is UpdateSurveyResponse){
      emit(const ApiLoadingState());
      final answerBody = {
        '_method': 'put',
        'answers' : event.updateAnswers
      };
      try {
        ApiResult<SurveyResponseModel> surveyResponse = await surveyRepository.updateSurveyResponse(answerBody, event.filePaths,event.responseId);
        surveyResponse.when(
          success: (SurveyResponseModel surveyAnswer) async {
            emit(UpdateResponseDetailSuccess(data: surveyAnswer));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }

  getSurveyResponseList(SurveyEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is GetSurveyResponseList){
      emit(const ApiLoadingState());
      final params = {
        'survey_id' : event.surveyId,
        'page' : event.pageCount
      };
      try {
        ApiResult<SurveyResponseList> surveyListResponse = await surveyRepository.surveyResponseList(params);
        surveyListResponse.when(
          success: (SurveyResponseList surveyResponse) async {
            emit(SurveyResponseListStateSuccess(data: surveyResponse));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }
  fetchResponseDetails(SurveyEvent event, Emitter<GlobalApiResponseState> emit) async{
    if(event is FetchResponseDetails){
      emit(const ApiLoadingState());
      try {
        ApiResult<ResponseDetailsModel> surveyListResponse = await surveyRepository.responseDetails(event.userId);
        surveyListResponse.when(
          success: (ResponseDetailsModel responseDetails) async {
            emit(ResponseDetailsStateSuccess(data: responseDetails));
          },
          failure: (AppException ex) async {
            emit(ApiErrorState(exception: ex));
          },
        );
      } on AppException catch (e) {
        emit(ApiErrorState(exception: e));
      }
    }
  }

}
