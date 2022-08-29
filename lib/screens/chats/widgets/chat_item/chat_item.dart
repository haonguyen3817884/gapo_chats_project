import 'package:base_flutter/models/api/chat.dart';
import 'package:base_flutter/screens/chats/widgets/avatar_chat.dart';
import 'package:base_flutter/screens/chats/widgets/chat_item/body_chat_item.dart';
import 'package:flutter/material.dart';
import "package:base_flutter/screens/chats/chats_controller.dart";
import 'package:get/get.dart';

class ChatItem extends GetView<ChatsController> {
  const ChatItem({
    Key? key,
    required this.chat,
  }) : super(key: key);
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //avatar
              AvatarChat(
                imageUrl: chat.avatar,
                width: 64,
                height: 64,
                isActive: chat.isActive(),
              ),
              //body
              BodyChatItem(chat: chat),
            ],
          ),
        ),
        onTap: () {
          controller.goToSelectedConversationScreen(chat);
        });
  }
}
