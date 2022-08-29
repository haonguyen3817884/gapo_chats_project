import 'dart:convert';

import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:base_flutter/generated/locales.g.dart';

import "package:base_flutter/models/api/chat_message_body.dart";
import "package:base_flutter/models/api/chat_thread.dart";

ChatMessage chatMessageFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  ChatMessage({required this.body, required this.thread});

  final MessageBody body;

  final Thread thread;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      body: MessageBody.fromJson(json["body"]),
      thread: Thread.fromJson(json["thread"]));

  Map<String, dynamic> toJson() =>
      {"body": body.toJson(), "thread": thread.toJson()};
}
