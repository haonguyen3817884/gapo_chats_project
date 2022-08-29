import 'package:flutter/material.dart';
import "package:base_flutter/screens/chats/selected_conversation/selected_conversation_controller.dart";
import 'package:get/get.dart';
import "package:base_flutter/screens/chats/selected_conversation/widgets/selected_conversation_header.dart";
import "package:base_flutter/screens/chats/selected_conversation/widgets/selected_conversation_input.dart";

class SelectedConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectedConversationController());
  }
}

class SelectedConversationScreen
    extends GetView<SelectedConversationController> {
  const SelectedConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  SelectedConversationHeader(),
                  Expanded(
                      child: Stack(children: <Widget>[
                    Align(
                        child: Container(
                            child: Obx(() {
                              return Material(
                                  child: ListView.builder(
                                      itemCount:
                                          controller.customerLength.value,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                            title: Text(controller
                                                .customers[index].name),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              controller.onUsernameClicked(
                                                  controller.customers[index]);
                                            },
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.black,
                                                    width: 1.5,
                                                    style: BorderStyle.solid)));
                                      },
                                      shrinkWrap: true));
                            }),
                            constraints: BoxConstraints(maxHeight: 74.0)),
                        alignment: Alignment.bottomLeft)
                  ])),
                  Padding(
                      child: SelectedConversationInput(),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ]))));
  }
}
