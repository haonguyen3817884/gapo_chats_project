import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/models/api/chat.dart';
import 'package:base_flutter/screens/chats/chats_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ActionSheetMore extends GetView<ChatsController> {
  const ActionSheetMore({Key? key, required this.chat}) : super(key: key);
  final ChatModel chat;
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(LocaleKeys.chat_pick_function.tr),
      actions: [
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_block_message.tr),
          isDefaultAction: true,
          onPressed: () async {},
        ),
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_pin.tr),
          isDefaultAction: true,
          onPressed: () async {},
        ),
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_turn_off_notification.tr),
          isDefaultAction: true,
          onPressed: () async {},
        ),
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_turn_on_secret_conversation.tr),
          isDefaultAction: true,
          onPressed: () async {},
        ),
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_store_conversation.tr),
          isDefaultAction: true,
          onPressed: () async {
            controller.storeConversation(chat: chat);
          },
        ),
        CupertinoActionSheetAction(
          child: Text(LocaleKeys.chat_delete_conversation.tr),
          isDestructiveAction: true,
          onPressed: () async {},
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(LocaleKeys.chat_cancel.tr),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
