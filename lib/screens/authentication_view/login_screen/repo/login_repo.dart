
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/networkSupport/base/ApiResult.dart';
import 'package:mserp/networkSupport/base/NetworkService.dart';
import 'package:mserp/screens/authentication_view/login_screen/model/LoginAuthModel.dart';
import 'package:mserp/supports/AppException.dart';

class LoginRepository{
  final NetworkService networkService = NetworkService();
  LoginRepository();

  Future<ApiResult<LoginAuthModel>> login(dynamic bodyParams) async {
    try {
      final response = await networkService.post(ApiConstants.authUrl, null, null, bodyParams);
      return ApiResult.success(data: LoginAuthModel.fromJson(response));
    } on AppException catch (e) {
      return ApiResult.failure(error: e);
    }
  }
}