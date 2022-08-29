import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:base_flutter/base/networking/base/interceptors/authentication_interceptor.dart';
import 'package:base_flutter/base/networking/base/interceptors/logger_interceptor.dart';
import 'package:base_flutter/base/networking/base/interceptors/token_interceptor.dart';
import 'package:base_flutter/base/networking/base/response_error.dart';
import 'package:base_flutter/configs/constants.dart';

import 'app_exception.dart';

/// initialize a service with base url
class ApiService {
  static Dio? _dio;
  String baseUrl;
  late Options requestOptions;

  ApiService(
    this.baseUrl, {
    Duration timeout = const Duration(seconds: 60),
  }) {
    requestOptions = _initRequestOptions(timeout: timeout);
    _setupDio();
  }

  Options _initRequestOptions({
    Duration timeout = const Duration(seconds: 60),
  }) {
    return Options(
      receiveDataWhenStatusError: true,
      receiveTimeout: timeout.inMilliseconds,
    );
  }

  void _setupDio() {
    if (_dio != null) return;

    // create dio instance with options above
    _dio = Dio();
  }

  Future<Response<T>> getData<T>({
    required String endPoint,
    Options? options,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.get<T>(baseUrl + endPoint,
          queryParameters: query, cancelToken: cancelToken, options: options);
      return response;
    } catch (e) {
      throw _parseError(e);
    }
  }

  Future<Response<T>> postData<T>({
    required String endPoint,
    dynamic body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Response<T> response = await _dio!.post<T>(
        baseUrl + endPoint,
        queryParameters: query,
        data: body,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      throw _parseError(e);
    }
  }

  Future<Response<T>> putData<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.put<T>(baseUrl + endPoint,
          queryParameters: query,
          data: body,
          cancelToken: cancelToken,
          options: requestOptions);
      return response;
    } catch (e) {
      throw _parseError(e);
    }
  }

  Future<Response<T>> patchData<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.patch<T>(baseUrl + endPoint,
          queryParameters: query,
          data: body,
          cancelToken: cancelToken,
          options: requestOptions);
      return response;
    } catch (e) {
      throw _parseError(e);
    }
  }

  Future<Response<T>> delete<T>({
    required String endPoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    try {
      Response<T> response = await _dio!.delete<T>(
        baseUrl + endPoint,
        queryParameters: query,
        data: body,
        cancelToken: cancelToken,
        options: _initRequestOptions()
          ..contentType =
              "application/x-www-form-urlencoded", // calendar service không cho phép truyền content-type = "application/json" khi body null
      );
      return response;
    } catch (e) {
      throw _parseError(e);
    }
  }

  Object _parseError(Object e) {
    if (e is DioError) {
      switch (e.type) {
        // got response error
        case DioErrorType.response:
          ResponseError? responseError;
          if (e.response != null) {
            responseError = ResponseError.fromDioResponse(e.response!);
          }
          switch (e.response?.statusCode) {
            case 400:
              throw BadRequestException(
                  response: responseError, message: responseError?.message);
            case 401:
            case 403:
              throw UnauthorisedException(
                  response: responseError, message: responseError?.message);
            case 405:
              throw MethodNotAllowedException(
                  response: responseError, message: responseError?.message);
            case 500:
            default:
              throw FetchDataException(
                  response: responseError, message: responseError?.message);
          }
        // connection error
        default:
          throw e;
      }
    }
    return e;
  }
}
