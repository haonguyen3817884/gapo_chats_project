import 'dart:convert';

import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:base_flutter/generated/locales.g.dart';

CustomerInfo customerInfoFromJson(String str) =>
    CustomerInfo.fromJson(json.decode(str));

String customerInfoToJson(CustomerInfo data) => json.encode(data.toJson());

class CustomerInfo {
  CustomerInfo(
      {required this.email,
      required this.name,
      required this.avatar,
      required this.id});

  final String name;
  final String avatar;
  final String email;

  final int id;

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
      email: json["email"] ?? "",
      avatar: json["avatar"] ??
          'https://cdn-thumb-image-1.gapowork.vn/312x312/smart/79a0096a-7f0a-4495-aa53-b0fddaaddc64.jpeg',
      name: json["display_name"] ?? "",
      id: json["user_id"] ?? 0);

  Map<String, dynamic> toJson() =>
      {"email": email, "display_name": name, "avatar": avatar, "user_id": id};
}
