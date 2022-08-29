import "package:base_flutter/base/controller/base_controller.dart";
import "package:base_flutter/models/api/chat.dart";
import 'package:get/get.dart';

import "package:base_flutter/models/api/customer_info.dart";

import "package:base_flutter/base/networking/services/customer_api.dart";
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';

import "package:base_flutter/screens/chats/selected_conversation/conversation_text_editing_controller.dart";

import "package:base_flutter/base/networking/services/mqtt_service.dart";

import "package:base_flutter/models/api/chat.dart";

class SelectedConversationController extends BaseController {
  var data = Get.arguments;
  final CustomerApi _customerApi = CustomerApi();

  List<CustomerInfo> customers = <CustomerInfo>[].obs;

  RxInt customerLength = 0.obs;

  ConversationTextEditingController textEditingController =
      ConversationTextEditingController([]);

  int lastTextLength = 0;

  String lastText = "";

  RxInt inputPosition = 0.obs;

  int includedPosition = -1;

  List<CustomerInfo> includedCustomers = <CustomerInfo>[];

  Future<void> getCustomers(String text) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      List<CustomerInfo> data = await _customerApi.getCustomers(text: text);
      customers = data.obs;

      customerLength.value = data.length;
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: GPColor.workPrimary,
        messageText: Text(
          LocaleKeys.chat_errorNotification.tr,
          style: textStyle(GPTypography.bodyMedium)
              ?.merge(const TextStyle(color: GPColor.contentInversePrimary)),
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  void onUsernameClicked(CustomerInfo customerInfo) {
    refreshCustomer();

    includedCustomers.add(customerInfo);

    lastText = textEditingController.text
            .substring(0, textEditingController.text.lastIndexOf("@")) +
        "~" +
        customerInfo.name +
        textEditingController.text.substring(inputPosition.value);

    lastTextLength = lastText.length;

    textEditingController.text = lastText;

    textEditingController.selection = TextSelection(
        baseOffset: textEditingController.text.lastIndexOf("~"),
        extentOffset: textEditingController.text.lastIndexOf("~") +
            customerInfo.name.length +
            1);

    includedPosition = -1;
  }

  void onTextDeleted() {
    int index = 0;
    index = lastText.substring(0, inputPosition.value).lastIndexOf("~");

    if (index == -1) {
      inputPosition.value = inputPosition.value - 1;
    } else {
      bool isIncluded = false;

      for (int i = 0; i < includedCustomers.length; ++i) {
        if (("~" + includedCustomers[i].name)
            .contains(lastText.substring(index, inputPosition.value))) {
          isIncluded = true;

          lastText = lastText.substring(0, index) +
              lastText.substring(index + includedCustomers[i].name.length + 1);

          lastTextLength = lastText.length;

          textEditingController.text = lastText;

          includedCustomers.removeAt(i);

          break;
        }
      }

      if (!isIncluded) {
        inputPosition.value = inputPosition.value - 1;
      }
    }
  }

  void refreshCustomer() {
    customers = <CustomerInfo>[].obs;

    customerLength.value = 0;
  }

  void setInputPosition() {
    inputPosition.value = textEditingController.selection.baseOffset;
  }

  void onTextUpdated() {
    inputPosition.value = inputPosition.value + 1;
  }

  @override
  void onInit() async {
    textEditingController.setCustomers =
        await _customerApi.getCustomers(text: "");

    inputPosition.listen((value) async {
      if (textEditingController.text.substring(0, value).contains("@")) {
        if (includedPosition == -1) {
          if (textEditingController.text[value - 1] == "@") {
            includedPosition = value - 1;

            await getCustomers("");
          }
        } else {
          if (value > includedPosition + 1) {
            await getCustomers(textEditingController.text
                .substring(includedPosition + 1, value));
          } else if (value == includedPosition + 1) {
            await getCustomers("");
          } else {
            refreshCustomer();
          }
        }
      } else {
        if (!textEditingController.text.contains("@")) {
          includedPosition = -1;

          refreshCustomer();
        }
      }
    });

    textEditingController.addListener(() {
      if (lastTextLength > textEditingController.text.length) {
        onTextDeleted();
      } else if (lastTextLength < textEditingController.text.length) {
        onTextUpdated();
      }

      lastTextLength = textEditingController.text.length;

      lastText = textEditingController.text;
    });

    super.onInit();
  }
}
