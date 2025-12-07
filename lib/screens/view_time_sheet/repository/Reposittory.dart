

import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/view_time_sheet/model/AttendenceResponse.dart';
import 'package:mserp/supports/AppException.dart';

class Repository{
  final NetworkService networkService = NetworkService();

  Repository();

  Future<ApiResult<AttendenceResponse>> getAttendance() async {
    try {
      final response = await networkService.get(ApiConstants.attendanceEndPoint, null, null);
      return ApiResult.success(data: AttendenceResponse.fromJson(response));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}