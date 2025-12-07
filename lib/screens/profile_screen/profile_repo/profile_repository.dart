
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/profile_screen/model/ProfileResponse.dart';
import 'package:mserp/supports/AppException.dart';

class ProfileRepository{
  final NetworkService networkService = NetworkService();
  ProfileRepository();

  Future<ApiResult<ProfileResponse>> getProfile() async{
    try {
      final profileResponse = await networkService.get(ApiConstants.profileEndPoint, null, null);
      return ApiResult.success(data: ProfileResponse.fromJson(profileResponse));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}