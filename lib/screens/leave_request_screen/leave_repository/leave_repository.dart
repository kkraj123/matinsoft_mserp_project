
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRemoveResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveRequestResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/LeaveTypeResponse.dart';
import 'package:mserp/screens/leave_request_screen/model/MyLeaveStatusResponse.dart';
import 'package:mserp/supports/AppException.dart';

class LeaveRepository{
  final NetworkService networkService = NetworkService();

  LeaveRepository();

  Future<ApiResult<LeaveTypeResponse>> getLeaveType() async{
    try {
      final responseLeaveType = await networkService.get(ApiConstants.leaveTypeEndPoint, null, null);
      return ApiResult.success(data: LeaveTypeResponse.fromJson(responseLeaveType));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<LeaveRequestResponse>> requestLeave(dynamic bodyParams) async{
    try {
      final responseLeaveRequest = await networkService.post(ApiConstants.leaveRequestEndPoint, null, null,bodyParams);
      return ApiResult.success(data: LeaveRequestResponse.fromJson(responseLeaveRequest));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<MyLeaveStatusResponse>> getMyLeaveStatus() async{
    try {
      final responseLeaveStatus = await networkService.get(ApiConstants.leaveRequestEndPoint, null, null);
      return ApiResult.success(data: MyLeaveStatusResponse.fromJson(responseLeaveStatus));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
  Future<ApiResult<LeaveRemoveResponse>> removeLeaveItem(dynamic removeLeaveId) async{
    try {
      final responseLeaveRemove = await networkService.delete("${ApiConstants.leaveRequestEndPoint}/$removeLeaveId", null, null, null);
      return ApiResult.success(data: LeaveRemoveResponse.fromJson(responseLeaveRemove));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}