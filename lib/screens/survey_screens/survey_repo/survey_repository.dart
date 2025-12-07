
 import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/survey_screens/model/ResponseDetailsModel.dart';
import 'package:mserp/screens/survey_screens/model/SurveyListResponse.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseList.dart';
import 'package:mserp/screens/survey_screens/model/SurveyResponseModel.dart';
import 'package:mserp/supports/AppException.dart';

class SurveyRepository{
  final NetworkService networkService = NetworkService();

  SurveyRepository();

  Future<ApiResult<SurveyListResponse>> getSurveyList(dynamic pageCount) async {
    try {
      final surveyListResponse = await networkService.get(ApiConstants.surveyListEndPoint, pageCount, null);
      return ApiResult.success(data: SurveyListResponse.fromJson(surveyListResponse));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<SurveyResponseModel>> answerSurveyResponse(
      Map<String, dynamic> responseBody,
      Map<int, String>? filePaths,
      ) async {
    try {
      dynamic surveyAnswer;

      if (filePaths != null && filePaths.isNotEmpty) {
        surveyAnswer = await networkService.postWithFiles(
          ApiConstants.responseApiEndPoint,
          null,
          null,
          responseBody,
          filePaths,
        );
      } else {
        // Use regular JSON request if no files
        surveyAnswer = await networkService.post(
          ApiConstants.responseApiEndPoint,
          null,
          null,
          responseBody,
        );
      }

      return ApiResult.success(data: SurveyResponseModel.fromJson(surveyAnswer));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<SurveyResponseModel>> updateSurveyResponse(
      Map<String, dynamic> responseBody,
      Map<int, String>? filePaths,
      dynamic responseId
      ) async {
    try {
      dynamic updateAnswers;

      if (filePaths != null && filePaths.isNotEmpty) {
        updateAnswers = await networkService.postWithFiles(
          "${ApiConstants.updateSurveyResponse}/$responseId",
          null,
          null,
          responseBody,
          filePaths,
        );
      } else {
        // Use regular JSON request if no files
        updateAnswers = await networkService.post(
          "${ApiConstants.updateSurveyResponse}/$responseId",
          null,
          null,
          responseBody,
        );
      }

      return ApiResult.success(data: SurveyResponseModel.fromJson(updateAnswers));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }

  Future<ApiResult<SurveyResponseList>> surveyResponseList(dynamic params) async {
    try {
      final surveyAnswer = await networkService.get(ApiConstants.getResponseService, params, null);
      return ApiResult.success(data: SurveyResponseList.fromJson(surveyAnswer));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<ResponseDetailsModel>> responseDetails(dynamic userId) async {
    try {
      final responseDetails = await networkService.get("${ApiConstants.getResponseService}/$userId", null, null);
      return ApiResult.success(data: ResponseDetailsModel.fromJson(responseDetails));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
 }