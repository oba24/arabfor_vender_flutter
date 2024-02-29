import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart' as lang;
import '../generated/locale_keys.g.dart';
import '../helper/loger.dart';
import '../helper/user_data.dart';

// ignore: constant_identifier_names
// const String BASE_URL = "https://khlod.aait-d.com/saudi_marsheeh/public/api";
const String BASE_URL = "https://arabfor.sa/saudi_marsheeh/public/api";
// const String BASE_URL = "https://192.168.115.64:8000/api";

class ServerGate {
  Dio dio = Dio();
  final LoggerDebug log = LoggerDebug(
    headColor: LogColors.black,
    constTitle: "--------- Server Gate Logger -------->",
  );
  ServerGate() {
    addInterceptors();
  }
  CancelToken cancelToken = CancelToken();

  Map<String, dynamic> _header() {
    return {
      "Authorization": "Bearer ${UserHelper.accessToken}",
      "Accept": "application/json",
      "Accept-Language": LocaleKeys.Lang.tr(),
    };
  }

  void addInterceptors() {
    dio.interceptors.add(CustomApiInterceptor(log));
  }

  // [][][][][][][][][][][][][] POST DATA TO SERVER [][][][][][][][][][][][][] //
  StreamController<double> onSingleReceive = StreamController.broadcast();

  Future<CustomResponse<T>> sendToServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? callback,
  }) async {
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
      log.white("------ body for this req. -----");
      Map<String, String> _buildBody =
          body.map((key, value) => MapEntry(key, value.toString()));
      log.white(jsonEncode(_buildBody));
    }
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      Response response = await dio.post(
        "$BASE_URL/$url",
        data: FormData.fromMap(body ?? {}),
        onSendProgress: (received, total) {
          onSingleReceive.add((received / total) - 0.05);
          //  print((received / total * 100).toStringAsFixed(0) + "%");
        },
        options: Options(
          sendTimeout: 5000,
          receiveTimeout: 5000,
          contentType:
              "multipart/form-data; boundary=<calculated when request is sent>",
          headers: headers,
        ),
      );

      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        msg: response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null ? null : objectFromJson<T>(callback, response),
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------- POST delete TO SERVER -------//
  Future<CustomResponse<T>> deleteFromServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    T Function(Map<String, dynamic>)? callback,
  }) async {
    // remove nulls from body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }
    // add stander header
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      Response response = await dio.delete(
        "$BASE_URL/$url",
        data: FormData.fromMap(body ?? {}),
        options: Options(
          headers: headers,
          sendTimeout: 5000,
          receiveTimeout: 5000,
        ),
      );

      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        msg: response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null ? null : objectFromJson<T>(callback, response),
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------- PUT DATA TO SERVER -------//
  Future<CustomResponse<T>> putToServer<T>({
    required String url,
    Map<String, dynamic>? headers,
    T Function(Map<String, dynamic>)? callback,
    Map<String, dynamic>? body,
  }) async {
    // remove nulls from body
    if (body != null) {
      body.removeWhere(
        (key, value) => body[key] == null || body[key] == "",
      );
    }
    // add stander header
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      Response response = await dio.put(
        "$BASE_URL/$url",
        data: FormData.fromMap(body ?? {}),
        options: Options(
          headers: headers,
          sendTimeout: 5000,
          receiveTimeout: 5000,
        ),
      );

      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        msg: response.data["message"] ?? "Your request completed succesfully",
        response: response,
        data: callback == null ? null : objectFromJson<T>(callback, response),
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  T objectFromJson<T>(
      T Function(Map<String, dynamic>) callback, Response response) {
    try {
      if (response.data != null && response.data is Map<String, dynamic>) {
        return callback(response.data);
      }
      return callback({});
    } catch (e) {
      response.data = {
        "message": kDebugMode
            ? e.toString()
            : LocaleKeys.Oups_Something_went_wrong.tr()
      };
      response.statusCode = 500;
      throw DioError(
        requestOptions: response.requestOptions,
        response: response,
        type: DioErrorType.response,
      );
    }
  }

  // ------ GET DATA FROM SERVER -------//
  Future<CustomResponse<T>> getFromServer<T>(
      {required String url,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params,
      T Function(Map<String, dynamic>)? callback}) async {
    // addInterceptors();
    // add stander header
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere((key, value) => value == null || value == "");
    } else {
      headers = _header();
    }
    // remove nulls from params
    if (params != null) {
      params.removeWhere(
          (key, value) => params[key] == null || params[key] == "");
    }
    try {
      Response response = await dio.get(
        url.startsWith("http") ? url : "$BASE_URL/$url",
        options: Options(
          headers: headers,
          sendTimeout: 5000,
          receiveTimeout: 5000,
        ),
        queryParameters: params,
      );

      return CustomResponse<T>(
        success: true,
        statusCode: 200,
        errType: null,
        msg: (response.data["message"] ?? "Your request completed succesfully")
            .toString(),
        response: response,
        data: callback == null ? null : objectFromJson<T>(callback, response),
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // ------ Download DATA FROM SERVER -------//

  Future<CustomResponse> downloadFromServer({
    required String url,
    required String path,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    dio = Dio();
    // add stander header
    if (headers != null) {
      headers.addAll(_header());
      headers.removeWhere(
          (key, value) => headers![key] == null || headers[key] == "");
    } else {
      headers = _header();
    }

    try {
      Response response =
          await dio.download(url, path, onReceiveProgress: (received, total) {
        onSingleReceive.add((received / total));
      });
      return CustomResponse(
        success: true,
        statusCode: 200,
        errType: null,
        msg: "Your request completed succesfully",
        response: response,
      );
    } on DioError catch (err) {
      return handleServerError(err);
    }
  }

  // -------- HANDLE ERROR ---------//
  CustomResponse<T> handleServerError<T>(DioError err) {
    if (err.type == DioErrorType.response) {
      if (err.response!.data.toString().contains("DOCTYPE") ||
          err.response!.data.toString().contains("<script>") ||
          err.response!.data["exception"] != null) {
        return CustomResponse(
          success: false,
          errType: 2,
          statusCode: err.response!.statusCode ?? 500,
          msg: LocaleKeys.Server_Error_Please_try_again_later.tr(),
          response: null,
        );
      }
      if (err.response!.statusCode == 401) {
        // UserHelper.logout();
        // SnackHelper.infoBar(message: lang.tr(LocaleKeys.Validator_Validate_The_registration_session_ended));
      }
      try {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: (err.response!.data["errors"] as Map).values.first.first,
          response: err.response,
        );
      } catch (e) {
        return CustomResponse(
          success: false,
          statusCode: err.response?.statusCode ?? 500,
          errType: 1,
          msg: err.response?.data["message"],
          response: err.response,
        );
      }
    } else if (err.type == DioErrorType.receiveTimeout ||
        err.type == DioErrorType.sendTimeout) {
      return CustomResponse(
        success: false,
        statusCode: err.response?.statusCode ?? 500,
        errType: 0,
        msg: LocaleKeys.Poor_Connection_Check_the_quality_of_the_internet.tr(),
        response: null,
      );
    } else {
      if (err.response == null) {
        return CustomResponse(
          success: false,
          statusCode: 402,
          errType: 0,
          msg: LocaleKeys.No_connection_check_the_quality_of_the_internet.tr(),
          response: null,
        );
      }
      return CustomResponse(
        success: false,
        statusCode: 402,
        errType: 2,
        msg: LocaleKeys.Server_Error_Please_try_again_later.tr(),
        response: null,
      );
    }
  }
}

class CustomApiInterceptor extends Interceptor {
  LoggerDebug log;
  CustomApiInterceptor(this.log);
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log.red(
        "--------- Server Gate Logger --------> \x1B[37m------ Current Error Response -----\x1B[0m");
    log.red(
        "--------- Server Gate Logger --------> \x1B[31m${err.response?.data}\x1B[0m");
    return super.onError(err, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    log.green("------ Current Response ------");
    log.green(jsonEncode(response.data));
    return super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.cyan("------ Current Request Parameters Data -----");
    log.cyan("${options.queryParameters}");
    log.yellow("------ Current Request Headers -----");
    log.yellow("${options.headers}");
    log.yellow("------ Current Request Path -----");
    log.yellow(
        "${options.path} ${LogColors.red}API METHOD : (${options.method})${LogColors.reset}");
    return super.onRequest(options, handler);
  }
}

class CustomResponse<T> {
  bool success;
  int? errType;
  // 0 => network error
  // 1 => error from the server
  // 2 => other error
  String msg;
  int statusCode;
  Response? response;
  T? data;

  CustomResponse({
    this.success = false,
    this.errType = 0,
    this.msg = "",
    this.statusCode = 0,
    this.response,
    this.data,
  });
}

class CustomError {
  int? type;
  String? msg;
  dynamic error;

  CustomError({
    this.type,
    this.msg,
    this.error,
  });
}
