import 'dart:convert';

import "package:base_flutter/base/networking/base/api.dart";
import "package:base_flutter/models/base/api_response.dart";
import "package:base_flutter/configs/constants.dart";
import "package:base_flutter/models/api/customer_login.dart";
import 'package:dio/dio.dart';
import "package:base_flutter/models/api/customer_info.dart";
import "package:base_flutter/models/base/list_api_response.dart";
import 'package:flutter/services.dart';

class CustomerApi {
  final ApiService _apiService = ApiService(Constants.apiLoginBase);

  Future<CustomerLogin> getCustomer() async {
    try {
      var body = {
        "client_id": "6n6rwo86qmx7u8aahgrq",
        "device_model": "Simulator iPhone 11",
        "device_id": "76cce865cbad4d02",
        "password":
            "4bff60a3797bc8053cd40253218c93afa7962fb966d012c844e254ad7788147e",
        "trusted_device": true,
        "email": "nguyenmanhtoan@gapo.com.vn"
      };

      var headers = {
        "x-gapo-workspace-id": 581860791816317,
        "x-gapo-lang": "vi",
        "x-gapo-user-id": 1042179540
      };

      Options options = Options(
          receiveDataWhenStatusError: true,
          receiveTimeout: Duration(seconds: 60).inMilliseconds,
          headers: headers);

      final response = await _apiService.postData(
          endPoint: Constants.customerLogin, options: options, body: body);

      ApiResponse<CustomerLogin> result = ApiResponse.fromJson(response.data);

      return result.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomerInfo> getCustomerInfo(int user_id, String token) async {
    try {
      var headers = {
        "x-gapo-workspace-id": 581860791816317,
        "x-gapo-lang": "vi",
        "x-gapo-user-id": user_id,
        "Authorization": "Bearer " + token
      };

      Options options = Options(
          receiveDataWhenStatusError: true,
          receiveTimeout: Duration(seconds: 60).inMilliseconds,
          headers: headers);

      final response = await _apiService.getData(
          endPoint: Constants.customerInfo + "/" + user_id.toString(),
          options: options);

      ApiResponse<CustomerInfo> result = ApiResponse.fromJson(response.data);

      return result.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CustomerInfo>> getCustomers({required String text}) async {
    List<CustomerInfo> customers = [];
    //get local sample data instead of call api
    try {
      final data = await _loadDataFromAsset(
        path: 'assets/sample_data/assignee (15).json',
      );
      if (data["data"] != null) {
        ListAPIResponse<CustomerInfo> result = ListAPIResponse.fromJson(data);
        for (int i = 0; i < result.data.length; ++i) {
          if (result.data[i].name.contains(text)) {
            customers.add(result.data[i]);
          }
        }
      }
      return customers;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> _loadDataFromAsset({required String path}) async {
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return data;
  }
}
