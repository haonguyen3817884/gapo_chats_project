import 'package:base_flutter/base/widgets/base_smart_refresher_v2.dart';
import 'package:base_flutter/models/api/chat.dart';
import 'package:base_flutter/screens/chats/stored_conversation/stored_conversation_controller.dart';
import 'package:base_flutter/screens/chats/stored_conversation/widgets/dismissible_item.dart';
import 'package:base_flutter/screens/chats/widgets/empty_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StoredConversationBody extends GetView<StoredConversationController> {
  const StoredConversationBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<dynamic> chats = [];
      if (controller.storedConversations.isEmpty &&
          controller.isLoading.value) {
        chats = List.generate(10, (index) => ChatModel(loading: true)).toList();
      } else {
        chats = controller.storedConversations;
      }
      return (chats.isEmpty)
          ? const EmptyConversations()
          : BaseSmartFresherV2(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return DismissibleStoredConversationItem(
                    chat: chats[index] as ChatModel,
                    index: index,
                  );
                },
              ),
              onRefresh: controller.onReload,
              onLoadMore: controller.onLoadMore,
            );
    });
  }
}
