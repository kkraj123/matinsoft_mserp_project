import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mserp/networkSupport/errorResponse/ErrorResponse.dart';
import 'package:mserp/networkSupport/errorResponse/OAuthError.dart';
import 'package:mserp/networkSupport/errorResponse/ResponseError.dart';
import 'package:mserp/networkSupport/errorResponse/auth_error.dart';
import 'package:mserp/supports/AppException.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../supports/AppLog.dart';
import '../ApiConstants.dart';
import 'interceptors/authorization_interceptor.dart';

class NetworkService {
  final String tag = "NetworkService";
  static const int timeoutDuration = 120;
  late final Dio dioNetworkService;

  NetworkService()
    : dioNetworkService = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: timeoutDuration),
            receiveTimeout: const Duration(seconds: timeoutDuration),
            responseType: ResponseType.json,
            followRedirects: false,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.addAll([
          AuthorizationInterceptor(),
          //LoggerInterceptor(),
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            filter: (options, args) {
              //  return !options.uri.path.contains('posts');
              return !args.isResponse || !args.hasUint8ListData;
            },
          ),
        ]);

  Future<dynamic> get(
    String endpointUrl,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }
    try {
      final response = await dioNetworkService.get(
        endpointUrl,
        queryParameters: params,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      // String errorBody = "${error.response}";
      String errorBody = jsonEncode(error.response?.data ?? {});
      AppLog.e(tag, "error string; $errorBody");
      handleError(errorBody);
    } on Exception catch (error) {
      throw AppException(error.toString());
    }
  }

  Future<dynamic> post(
    String endpointUrl,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic bodyParams,
    // Map<String, dynamic>? bodyParams,
  ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }
    try {
      final response = await dioNetworkService.post(
        endpointUrl,
        queryParameters: params,
        data: bodyParams,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      errorHandlingCode(error.response);
      // String errorBody = jsonEncode(error.response?.data ?? {});
      // print("errorResponse :$errorBody");
      // handleError(errorBody);
    } on Exception catch (error) {
      AppLog.e("Network service", "Error on post method : " + error.toString());
      throw AppException(error.toString());
    }
  }
  // Add this method to your NetworkService class

  // Add this method to your NetworkService class

  // Add this method to your NetworkService class

  Future<dynamic> postWithFiles(
      String endpointUrl,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      Map<String, dynamic> bodyParams,
      Map<int, String>? filePaths, // questionId -> filePath
      ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }

    try {
      // Create FormData
      final formData = FormData();

      // Add survey_id field
      final surveyId = bodyParams['survey_id'];
      if (surveyId == null) {
        formData.fields.add(const MapEntry('_method', 'put'));
      } else {
        formData.fields.add(MapEntry('survey_id', surveyId.toString()));
      }

      // formData.fields.add(MapEntry('survey_id', bodyParams['survey_id'].toString()));

      // Add answers as array format (not JSON string)
      final answers = bodyParams['answers'] as List<Map<String, dynamic>>;
      int answerIndex = 0;

      for (var answer in answers) {
        final questionId = answer['question_id'];

        formData.fields.add(
            MapEntry('answers[$answerIndex][question_id]', questionId.toString())
        );
        formData.fields.add(
            MapEntry('answers[$answerIndex][answer]', answer['answer'].toString())
        );

        answerIndex++;
      }

      // Add files if they exist
      if (filePaths != null && filePaths.isNotEmpty) {
        for (var entry in filePaths.entries) {
          final questionId = entry.key;
          final filePath = entry.value;
          final file = File(filePath);

          if (await file.exists()) {
            final fileName = filePath.split('/').last;

            // Add file answer entry
            formData.fields.add(
                MapEntry('answers[$answerIndex][question_id]', questionId.toString())
            );

            // Add the file with format answers[index][file]
            formData.files.add(
              MapEntry(
                'answers[$answerIndex][file]',
                await MultipartFile.fromFile(
                  filePath,
                  filename: fileName,
                ),
              ),
            );

            AppLog.d(tag, "Added file for question $questionId at index $answerIndex: $fileName");
            answerIndex++;
          } else {
            AppLog.e(tag, "File not found: $filePath");
          }
        }
      }

      // Make the request with multipart/form-data
      final response = await dioNetworkService.post(
        endpointUrl,
        queryParameters: params,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return handleResponse(response);
    } on DioException catch (error) {
      AppLog.e(tag, "Multipart upload error: ${error.message}");
      errorHandlingCode(error.response);
    } on Exception catch (error) {
      AppLog.e(tag, "Error on postWithFiles method: ${error.toString()}");
      throw AppException(error.toString());
    }
  }
  Future<dynamic> putWithFiles(
      String endpointUrl,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      Map<String, dynamic> bodyParams,
      Map<int, String>? filePaths,
      ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }

    try {
      // Create FormData
      final formData = FormData();

      // Add survey_id field
      formData.fields.add(MapEntry('survey_id', bodyParams['survey_id'].toString()));

      // Add answers as array format (not JSON string)
      final answers = bodyParams['answers'] as List<Map<String, dynamic>>;
      int answerIndex = 0;

      for (var answer in answers) {
        final questionId = answer['question_id'];

        formData.fields.add(
          MapEntry('answers[$answerIndex][question_id]', questionId.toString()),
        );
        formData.fields.add(
          MapEntry('answers[$answerIndex][answer]', answer['answer'].toString()),
        );

        answerIndex++;
      }

      // Add files if provided
      if (filePaths != null && filePaths.isNotEmpty) {
        for (var entry in filePaths.entries) {
          final questionId = entry.key;
          final filePath = entry.value;
          final file = File(filePath);

          if (await file.exists()) {
            final fileName = filePath.split('/').last;

            // Add file answer entry
            formData.fields.add(
              MapEntry('answers[$answerIndex][question_id]', questionId.toString()),
            );

            // Add the file
            formData.files.add(
              MapEntry(
                'answers[$answerIndex][file]',
                await MultipartFile.fromFile(filePath, filename: fileName),
              ),
            );

            AppLog.d(tag, "Added file for question $questionId at index $answerIndex: $fileName");
            answerIndex++;
          } else {
            AppLog.e(tag, "File not found: $filePath");
          }
        }
      }

      // Make PUT request
      final response = await dioNetworkService.put(
        endpointUrl,
        queryParameters: params,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return handleResponse(response);
    } on DioException catch (error) {
      AppLog.e(tag, "Multipart PUT upload error: ${error.message}");
      errorHandlingCode(error.response);
    } on Exception catch (error) {
      AppLog.e(tag, "Error on putWithFiles method: ${error.toString()}");
      throw AppException(error.toString());
    }
  }


  Future<dynamic> put(
    String endpointUrl,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic bodyParams,
  ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }

    try {
      final response = await dioNetworkService.put(
        endpointUrl,
        queryParameters: params,
        data: bodyParams,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      String errorBody = jsonEncode(error.response?.data ?? {});
      print("errorResponse :$errorBody");
      handleError(errorBody);
      throw AppException(error.message ?? 'Unknown error');
    } on Exception catch (error) {
      AppLog.e("Network service", "Error on put method: ${error.toString()}");
      throw AppException(error.toString());
    }
  }
  Future<dynamic> patch(
      String endpointUrl,
      Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      dynamic bodyParams,
      ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }

    try {
      final response = await dioNetworkService.patch(
        endpointUrl,
        queryParameters: params,
        data: bodyParams,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      String errorBody = jsonEncode(error.response?.data ?? {});
      AppLog.e(tag, "Patch error: $errorBody");
      handleError(errorBody);
      throw AppException(error.message ?? 'Unknown error');
    } on Exception catch (error) {
      AppLog.e(tag, "Patch method error: $error");
      throw AppException(error.toString());
    }
  }

  Future<dynamic> delete(
    String endpointUrl,
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic bodyParams,
  ) async {
    if (headers != null) {
      dioNetworkService.options.headers = headers;
    }
    try {
      final response = await dioNetworkService.delete(
        endpointUrl,
        queryParameters: params,
        data: bodyParams,
      );
      return handleResponse(response);
    } on DioException catch (error) {
      String errorBody = jsonEncode(error.response?.data ?? {});
      AppLog.e(tag, "Delete error: $errorBody");
      handleError(errorBody);
    } on Exception catch (error) {
      AppLog.e(tag, "Delete method error: $error");
      throw AppException(error.toString());
    }
  }

  Future<dynamic> postMultiPart(String endpointUrl, File image) async {
    try {
      var formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: 'image'),
      });
      final response = await Dio().post(endpointUrl, data: formData);
      if (response.statusCode == 200) {
      } else if (response.statusCode == 200) {
        //BotToast is a package for toasts available on pub.dev

        // Toastutils.showToast('Validation Error Occurs');
        print("Validation error Occurs");

        return false;
      }
    } on DioError catch (error) {
    } catch (_) {
      throw 'Something Went Wrong';
    }
  }

  dynamic handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        //return response.data;
      if (response.data is List) {
        return response.data;
      }

      if (response.data is Map<String, dynamic>) {
        Map<String, dynamic> jsonMap =
        response.data as Map<String, dynamic>;

        String code = jsonMap['code']?.toString().toLowerCase() ?? '';
        String status = jsonMap['status']?.toString().toLowerCase() ?? '';

        if (code == "m0000" || status == "failure") {
          throw AppException(jsonMap['message'] ?? "Unknown error");
        }

        return jsonMap;
      }
      return response.data;
        // Map<String, dynamic> jsonMap = response.data as Map<String, dynamic>;
        // String code = jsonMap['code']?.toString().toLowerCase() ?? '';
        // String status = jsonMap['status']?.toString().toLowerCase() ?? '';
        //
        // if (code == "M0000" || status == "failure") {
        //   // failure code
        //   // handleError(response.data);
        //   throw AppException("${jsonMap['message']}");
        // } else {
        //   return response.data;
        // }
      case 300:
      case 301:
      case 302:
      case 303:
      case 304:
      case 305:
      case 307:
      case 308:
      // For API calls, redirects are usually not expected
      // Log the redirect and throw an appropriate exception
        AppLog.d(tag, "Redirect received: ${response.statusCode} - ${response.realUri}");
        throw RedirectException("Redirect received with status 302", response.realUri as List<RedirectInfo>,);

      case 400:
        return handleError(response.data);
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
        throw InternalServerException(response.data.toString());
      default:
        throw FetchDataException(
          'Error occured while connecting with Server with StatusCode : ${response.statusCode}',
        );
    }
  }

  String handleErrorResponse(String errorBody) {
    OAuthError? oAuthError;
    try {
      oAuthError = OAuthError.fromJson(jsonDecode(errorBody));
      AppLog.d("NetworkService", "parsed as oauth");
    } on Exception catch (e) {
      AppLog.d("NetworkService", "unable to parse OAuthError");
    }

    ResponseError? responseError;
    try {
      responseError = ResponseError.fromJson(jsonDecode(errorBody));
    } on Exception catch (e) {
      AppLog.d("NetworkService", "unable to parse Response error");
    }

    if (oAuthError != null) {
      return oAuthError.errorDescription;
    } else if (responseError != null) {
      if (responseError.message != null) {
        return responseError.message!;
      } else {
        return "Please try again";
      }
    } else {
      return "Please try again";
    }
  }

  handleError(String errorBody) {
    bool _isRedirecting = false;
    OAuthError? oAuthError;
    try {
      oAuthError = OAuthError.fromJson(jsonDecode(errorBody));
      AppLog.d("NetworkService", "parsed as oauth");
    } catch (_) {}

    AuthError? authError;
    try {
      authError = AuthError.fromJson(jsonDecode(errorBody));
      AppLog.d("NetworkService", "parsed as auth error");
    } catch (_) {}

    Map<String, dynamic>? genericError;
    try {
      genericError = jsonDecode(errorBody);
    } catch (_) {}

    String errorMsg = "Please try again";

    if (oAuthError != null) {
      errorMsg = oAuthError.errorDescription;
    } else if (authError?.message != null) {
      errorMsg = authError!.message!;
    } else if (genericError?['message'] != null) {
      errorMsg = genericError!['message'];
    }

    // Map specific messages to exceptions
    if (errorMsg.contains("Bad credentials")) {
      throw BadRequestException(errorMsg);
    } else if (errorMsg.contains("unauthorized device.")) {
      throw UnauthorisedException(errorMsg);
    } else if (errorMsg.contains("Access token expired") || errorMsg.contains("Invalid access token") || errorMsg.contains("invalid_token") || errorMsg.contains("Unauthenticated")) {
      throw AccessTokenExpiredException(errorMsg);
    } else {
      throw AppException(errorMsg);
    }
  }

  void errorHandlingCode(Response<dynamic>? response) {
    if (response != null) {
      if (response.data is Map<String, dynamic>) {
        String errorBody = jsonEncode(response.data ?? {});
        print("errorResponse :$errorBody");
        handleError(errorBody);
      } else if (response.data is String) {
        // raw string (maybe HTML or plain error text)
        if (response.statusMessage != null) {
          errorHandling(response.statusMessage!);
        }
      } else {
        // fallback
        errorHandling(
          jsonEncode({"message": response.statusMessage ?? "Unknown error"}),
        );
      }
    }
  }

  errorHandling(String errorBody) {
    String errorMsg = "Please try again";

    try {
      final decoded = jsonDecode(errorBody);

      if (decoded is Map<String, dynamic>) {
        final errorResponse = ErrorResponse.fromJson(decoded);
        if (errorResponse.message != null &&
            errorResponse.message!.isNotEmpty) {
          errorMsg = errorResponse.message!;
        } else if (decoded['message'] != null) {
          errorMsg = decoded['message'];
        }
      }
    } catch (e) {
      AppLog.d(
        "NetworkService",
        "Failed to parse error as JSON, using raw text",
      );
      errorMsg = errorBody; // fallback to raw string
    }

    // Map specific messages to exceptions
    if (errorMsg.contains("Bad credentials")) {
      throw BadRequestException(errorMsg);
    } else if (errorMsg.contains("unauthorized device.")) {
      throw UnauthorisedException(errorMsg);
    } else if (errorMsg.contains("Access token expired") ||
        errorMsg.contains("Invalid access token") ||
        errorMsg.contains("invalid_token")) {
      throw AccessTokenExpiredException("Access token expired");
    } else {
      throw AppException(errorMsg);
    }
  }

  /* handleError(String errorBody) {
    OAuthError? oAuthError;
    try {
      oAuthError = OAuthError.fromJson(jsonDecode(errorBody));
      AppLog.d("NetworkService", "parsed as oauth");
    } catch (e) {
      AppLog.d("NetworkService", "unable to parse OAuthError ");
    }

    AuthError? authError;
    try {
      authError = AuthError.fromJson(jsonDecode(errorBody));
    } catch (e) {
      AppLog.d("NetworkService", "unable to parse Response error");
    }

    String errorMsg = "This is error";
    if (oAuthError != null) {
      errorMsg = oAuthError.errorDescription;
    } else if (authError != null) {
      if (authError.message != null) {
        errorMsg = authError.message!;
      } else {
        errorMsg = pleaseTryAgain;
      }
    } else {
      errorMsg = pleaseTryAgain;
    }

    //msg for access token expired
    //errorMsg = '{"error":"invalid_token","error_description":"Access token expired: 270f7b1e-072d-4703-aac5-f9c6b7879ffd"}';
    if (errorMsg.contains("Bad credentials")) {
      throw BadRequestException(errorMsg);
    } else if (errorMsg.contains("unauthorized device.")) {
      throw UnauthorisedException(errorMsg);
    } else if (errorMsg.contains("Access token expired") || errorMsg.contains("Invalid access token") || errorMsg.contains("invalid_token")) {
      throw AccessTokenExpiredException("Access token expired");
    } else {
      throw AppException(errorMsg);
    }
  }*/
}
