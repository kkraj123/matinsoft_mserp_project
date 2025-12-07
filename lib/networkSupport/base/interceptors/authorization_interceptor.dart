import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mserp/networkSupport/ApiConstants.dart';
import 'package:mserp/supports/AppLog.dart';
import 'package:mserp/supports/share_preference_manager.dart';

import '../../../screens/authentication_view/login_screen/model/LoginAuthModel.dart' show LoginAuthModel;



class AuthorizationInterceptor extends Interceptor {

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Initialize headers if null
    options.headers ??= {};

    // Only add auth header for non-auth endpoints
    if (options.path != ApiConstants.authUrl) {
      LoginAuthModel? oAuth = await SharedPreferenceManager.getOAuth();
      if (oAuth != null && oAuth.data!.accessToken != null) {
        options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${oAuth.data!.accessToken}';
      }
    }

    // Ensure consistent content-type
    if (!options.headers.containsKey(HttpHeaders.contentTypeHeader)) {
      options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    AppLog.i("AuthorizationInterceptor", "${options.headers}");
    super.onRequest(options, handler);
  }
}


