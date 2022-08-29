import 'dart:convert';

import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:base_flutter/generated/locales.g.dart';

CustomerLogin customerLoginFromJson(String str) =>
    CustomerLogin.fromJson(json.decode(str));

String customerLoginToJson(CustomerLogin data) => json.encode(data.toJson());

class CustomerLogin {
  CustomerLogin({required this.user_id, required this.access_token});

  final int user_id;

  final String access_token;

  factory CustomerLogin.fromJson(Map<String, dynamic> json) => CustomerLogin(
      user_id: json["user_id"] ?? 0, access_token: json["access_token"] ?? "");

  Map<String, dynamic> toJson() =>
      {"user_id": user_id, "access_token": access_token};
}
