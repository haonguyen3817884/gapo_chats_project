import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:base_flutter/screens/chats/selected_conversation/selected_conversation_controller.dart";
import 'package:get/get.dart';

class SelectedConversationInput
    extends GetView<SelectedConversationController> {
  const SelectedConversationInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
        placeholderStyle: textStyle(GPTypography.body16),
        controller: controller.textEditingController,
        textInputAction: TextInputAction.next,
        style: textStyle(GPTypography.body16),
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: GPColor.textFieldBkg,
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: () {
          controller.setInputPosition();
        },
        autocorrect: false);
  }
}
