import 'package:base_flutter/configs/path.dart';
import 'package:base_flutter/screens/chats/widgets/avatar_chat.dart';
import 'package:base_flutter/screens/chats/widgets/menu_function/menu_function.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:base_flutter/screens/chats/chats_controller.dart";
import 'package:get/get.dart';

class HeaderChats extends GetView<ChatsController> {
  const HeaderChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() {
          return AvatarChat(
            imageUrl: controller.customerInfo.value.avatar,
            width: 32,
            height: 32,
            isActive: true,
          );
        }),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Obx(() {
            return Text(
              controller.customerInfo.value.name,
              overflow: TextOverflow.ellipsis,
              style: textStyle(GPTypography.body16),
              // TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 1,
            );
          }),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const FractionallySizedBox(
                  child: MenuFunction(),
                  heightFactor: 0.45,
                );
              },
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            );
          },
          child: SizedBox(
            width: 30,
            height: 30,
            child: Stack(
              children: [
                Center(
                  child: SvgPicture.asset(
                    "assets/images/icon-menu.svg",
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: GPColor.functionNegativePrimary),
                    child: Center(
                      child: Text(
                        "9",
                        style: textStyle(GPTypography.bodySmallBold)?.merge(
                          const TextStyle(
                              color: GPColor.functionAlwaysLightPrimary),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 22,
        ),
        SvgPicture.asset(
          AppPaths.iconFolder,
        ),
        const SizedBox(
          width: 22,
        ),
        SvgPicture.asset(
          AppPaths.iconGreenEdit,
        ),
      ],
    );
  }
}
