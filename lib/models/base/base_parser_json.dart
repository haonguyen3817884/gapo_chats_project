import 'package:base_flutter/models/api/code_response.dart';
import 'package:base_flutter/models/api/login_response.dart';
import 'package:base_flutter/models/api/request_email_response.dart';

import 'package:base_flutter/models/api/user_info.dart';
import "package:base_flutter/models/api/customer_login.dart";

import "package:base_flutter/models/api/chat.dart";
import "package:base_flutter/models/api/customer_info.dart";
import "package:base_flutter/models/api/chat_message.dart";

mixin GPParserJson {
  static Map<Type, Function> _mapFactories<T>() {
    return <Type, Function>{
      T: (Map<String, dynamic> x) => _mapFactoryValue<T>(x),
    };
  }

  static dynamic _mapFactoryValue<T>(Map<String, dynamic> x) {
    // parse all items here
    switch (T) {
      case RequestEmailResponse:
        return RequestEmailResponse.fromJson(x);
      case LoginResponse:
        return LoginResponse.fromJson(x);
      case UserInfo:
        return UserInfo.fromJson(x);
      case ChatModel:
        return ChatModel.fromJson(x);
      case CustomerLogin:
        return CustomerLogin.fromJson(x);
      case CustomerInfo:
        return CustomerInfo.fromJson(x);
      case ChatMessage:
        return ChatMessage.fromJson(x);
      case String:
        return x as String;
      case CodeResponse:
        return CodeResponse.fromJson(x);
      default:
        throw Exception("ApiResponseExtension _mapFactoryValue error!!!");
    }
  }

  static T parseJson<T>(Map<String, dynamic> x) {
    Map<Type, Function> _factories = _mapFactories<T>();
    return _factories[T]?.call(x);
  }
}
