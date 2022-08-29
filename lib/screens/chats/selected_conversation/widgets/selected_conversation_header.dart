import 'package:base_flutter/configs/path.dart';
import 'package:base_flutter/screens/chats/widgets/avatar_chat.dart';
import 'package:base_flutter/screens/chats/widgets/menu_function/menu_function.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:base_flutter/screens/chats/chats_controller.dart";
import 'package:get/get.dart';
import "package:base_flutter/screens/chats/selected_conversation/selected_conversation_controller.dart";

class SelectedConversationHeader
    extends GetView<SelectedConversationController> {
  const SelectedConversationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AvatarChat(
          imageUrl: controller.data.avatar,
          width: 32,
          height: 32,
          isActive: true,
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Text(
            controller.data.name,
            overflow: TextOverflow.ellipsis,
            style: textStyle(GPTypography.body16),
            // TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
