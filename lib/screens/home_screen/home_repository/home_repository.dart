

import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/home_screen/model/CategoryItemsResponse.dart';
import 'package:mserp/screens/home_screen/model/CheckInCheckOutModel.dart';
import 'package:mserp/supports/AppException.dart';

class HomeRepository {
  final NetworkService networkService = NetworkService();

  HomeRepository();

  Future<ApiResult<CheckInCheckOutModel>> checkInCheckOutPost(dynamic bodyParams) async {
    try {
      final response = await networkService.post(ApiConstants.checkInCheckOutEndPoint, bodyParams, null, null);
      return ApiResult.success(data: CheckInCheckOutModel.fromJson(response));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }

  Future<ApiResult<CategoryItemsResponse>> categoryItems() async {
    try {
      final categoryResponse = await networkService.get(ApiConstants.categoryItemsEndPoint, null, null);
      return ApiResult.success(data: CategoryItemsResponse.fromJson(categoryResponse));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }

}