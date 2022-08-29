import 'dart:convert';

import 'package:base_flutter/configs/constants.dart';
import 'package:base_flutter/models/api/chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import "package:base_flutter/base/networking/base/api.dart";
import "package:base_flutter/models/base/list_api_response.dart";
import "package:base_flutter/models/base/api_response.dart";
import "package:base_flutter/models/api/chat_message.dart";

class ChatAPI {
  final ApiService _apiService = ApiService(Constants.apiChatBase);

  //have no api
  Future<List<ChatModel>> getChats({required int page}) async {
    List<ChatModel> chats = [];
    //get local sample data instead of call api
    try {
      final data = await _loadDataFromAsset(
        path: 'assets/sample_data/chat_response.json',
      );
      if (data["data"] != null) {
        List<dynamic> list = data["data"];
        for (int index = 0; index < list.length; index++) {
          //handle for load more without api
          if (index >= ((page - 1) * Constants.perPageSize) &&
              index < ((page) * Constants.perPageSize)) {
            chats.add(ChatModel.fromJson(list[index] as Map<String, dynamic>));
          }
          if (chats.length == Constants.perPageSize) {
            break;
          }
        }
      }
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatModel>> getChatsFromApi(
      {required int page,
      required String token,
      required int user_id,
      required List<ChatMessage> messages}) async {
    var query = {"page_size": 100};

    var headers = {
      "x-gapo-workspace-id": 581860791816317,
      "x-gapo-lang": "vi",
      "x-gapo-user-id": user_id,
      "Authorization": "Bearer " + token
    };

    Options options = Options(
        receiveDataWhenStatusError: true,
        headers: headers,
        receiveTimeout: Duration(seconds: 60).inMilliseconds);

    List<ChatModel> chats = [];
    //get local sample data instead of call api
    try {
      final response = await _apiService.getData(
          endPoint: Constants.getChats, options: options, query: query);

      ListAPIResponse<ChatModel> result =
          ListAPIResponse.fromJson(response.data);

      if (result.data.isNotEmpty) {
        List<ChatModel> list = result.data;

        for (int index = 0; index < list.length; index++) {
          //handle for load more without api
          if (index >= ((page - 1) * Constants.perPageSize) &&
              index < ((page) * Constants.perPageSize)) {
            if (messages.indexWhere((message) {
                  return message.thread.id == list[index].id;
                }) ==
                -1) {
              chats.add(list[index]);
            }
          }
          if (chats.length == Constants.perPageSize) {
            break;
          }
        }
      }

      return chats;
    } catch (e) {
      rethrow;
    }
  }

  Future<ChatModel> getChatFromApi(
      {required int threadId,
      required String token,
      required int user_id}) async {
    var headers = {
      "x-gapo-workspace-id": 581860791816317,
      "x-gapo-lang": "vi",
      "x-gapo-user-id": user_id,
      "Authorization": "Bearer " + token
    };

    Options options = Options(
        receiveDataWhenStatusError: true,
        headers: headers,
        receiveTimeout: Duration(seconds: 60).inMilliseconds);

    ChatModel chat = ChatModel();

    try {
      final response = await _apiService.getData(
          endPoint: Constants.getChats + "/" + threadId.toString(),
          options: options);

      ApiResponse<ChatModel> result = ApiResponse.fromJson(response.data);

      return result.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ChatModel>> getStoredConversations({required int page}) async {
    List<ChatModel> storedConversations = [];
    //get local sample data instead of call api
    try {
      final data = await _loadDataFromAsset(
        path: 'assets/sample_data/stored_conversation.json',
      );
      if (data["data"] != null) {
        List<dynamic> list = data["data"];
        for (int index = 0; index < list.length; index++) {
          //handle for load more without api
          if (index >= ((page - 1) * Constants.perPageSize) &&
              index < ((page) * Constants.perPageSize)) {
            storedConversations
                .add(ChatModel.fromJson(list[index] as Map<String, dynamic>));
          }
          if (storedConversations.length == Constants.perPageSize) {
            break;
          }
        }
      }
      return storedConversations;
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
