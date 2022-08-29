import 'package:base_flutter/configs/path.dart';
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/screens/chats/chats_controller.dart';
import 'package:base_flutter/screens/chats/widgets/menu_function/header.dart';
import 'package:base_flutter/screens/chats/widgets/menu_function/item_menu_function.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuFunction extends GetView<ChatsController> {
  const MenuFunction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderMenuFunction(),
        const Divider(
          height: 1,
          color: GPColor.linePrimary,
        ),
        const SizedBox(
          height: 8,
        ),
        ItemMenuFunction(
          text: LocaleKeys.chat_waiting_message.tr,
          iconPath: AppPaths.iconWaitingMessage,
          showCountInfo: true,
        ),
        ItemMenuFunction(
          text: LocaleKeys.chat_stored_message.tr,
          iconPath: AppPaths.iconStoredMessage,
          onTap: () {
            controller.goToStoredConversationScreen();
          },
        ),
      ],
    );
  }
}
