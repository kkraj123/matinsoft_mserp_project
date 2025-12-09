
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/budget_planning_screens/model/FamilyDashboardResponse.dart';
import 'package:mserp/supports/AppException.dart';

class FamilyRepository{
  final NetworkService networkService = NetworkService();
  FamilyRepository();

  Future<ApiResult<FamilyDashboardResponse>> login(dynamic userId) async {
    try {
      final response = await networkService.post(ApiConstants.familyDashboardEndPoint, null, null, userId);
      return ApiResult.success(data: FamilyDashboardResponse.fromJson(response));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}