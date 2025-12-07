
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRemoveResponse.dart';
import 'package:mserp/screens/time_leave_request/model/TimeLeaveRequestResponse.dart';
import 'package:mserp/screens/time_leave_request/model/TimeLeaveResponse.dart';
import 'package:mserp/supports/AppException.dart';

class TimeRepository{
  final NetworkService networkService = NetworkService();

  TimeRepository();

  Future<ApiResult<TimeLeaveRequestResponse>> timeLeaveRequest(dynamic bodyParams) async{
    try {
      final responseTimeLeaveRequest = await networkService.post(ApiConstants.timeLeaveRequestEndPoint, null, null,bodyParams);
      return ApiResult.success(data: TimeLeaveRequestResponse.fromJson(responseTimeLeaveRequest));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<TimeLeaveResponse>> timeLeaveFetch() async{
    try {
      final responseTimeLeave = await networkService.get(ApiConstants.timeLeaveRequestEndPoint, null, null);
      return ApiResult.success(data: TimeLeaveResponse.fromJson(responseTimeLeave));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<LeaveRemoveResponse>> deleteTimeLeave(dynamic timeLeaveId) async{
    try {
      final responseTimeLeaveRemove = await networkService.delete("${ApiConstants.timeLeaveRequestEndPoint}/$timeLeaveId", null, null, null);
      return ApiResult.success(data: LeaveRemoveResponse.fromJson(responseTimeLeaveRemove));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}