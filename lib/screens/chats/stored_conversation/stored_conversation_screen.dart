import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/screens/chats/stored_conversation/stored_conversation_controller.dart';
import 'package:base_flutter/screens/chats/stored_conversation/widgets/stored_conversation_body.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoredConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoredConversationController());
  }
}

class StoredConversation extends GetView<StoredConversationController> {
  const StoredConversation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            controller.backToPreviousScreen();
          },
          child: const Icon(Icons.arrow_back_ios_rounded),
        ),
        shadowColor: Colors.white,
        title: Text(
          LocaleKeys.chat_stored_message.tr,
          style: textStyle(GPTypography.headingMedium)
              ?.merge(const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: StoredConversationBody(),
      ),
    );
  }
}
