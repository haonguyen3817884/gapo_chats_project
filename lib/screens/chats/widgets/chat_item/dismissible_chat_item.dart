import 'package:base_flutter/configs/path.dart';
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/models/api/chat.dart';
import 'package:base_flutter/screens/chats/chats_controller.dart';
import 'package:base_flutter/screens/chats/widgets/chat_item/action_sheet.dart';
import 'package:base_flutter/screens/chats/widgets/chat_item/chat_item.dart';
import 'package:base_flutter/screens/chats/widgets/chat_item/chat_item_loading.dart';
import 'package:base_flutter/screens/chats/widgets/chat_item/dismissible_action.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class DismissibleChatItem extends GetView<ChatsController> {
  const DismissibleChatItem({
    Key? key,
    required this.chat,
    required this.index,
  }) : super(key: key);
  final ChatModel chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (chat.isLoading()) {
      return const ChatItemLoading();
    }
    return Slidable(
      key: Key((chat.id != null) ? chat.id.toString() : ""),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.45,
        children: [
          const SizedBox(
            width: 12,
          ),
          DismissibleAction(
            onTap: () {
              final action = ActionSheetMore(chat: chat);
              showCupertinoModalPopup(
                context: context,
                builder: (context) => action,
              );
            },
            backgroundColor: GPColor.bgTertiary,
            iconPath: AppPaths.iconMore,
            iconColor: GPColor.contentPrimary,
            text: LocaleKeys.chat_more.tr,
            textColor: GPColor.contentPrimary,
            flex: 1,
          ),
          DismissibleAction(
            onTap: () {
              controller.removeChat(chat: chat);
            },
            backgroundColor: GPColor.functionNegativePrimary,
            iconPath: AppPaths.iconRecycleBin,
            iconColor: GPColor.contentInversePrimary,
            textColor: GPColor.contentInversePrimary,
            text: LocaleKeys.chat_delete.tr,
          ),
        ],
      ),
      child: ChatItem(chat: chat),
    );
  }
}
