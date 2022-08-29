import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

 final List<String> tabsChats = [
  LocaleKeys.chat_all.tr,
   LocaleKeys.chat_mention.tr,
   LocaleKeys.chat_unread.tr,
   LocaleKeys.chat_product.tr
];

class ChatTabs extends StatefulWidget {
  const ChatTabs({Key? key}) : super(key: key);

  @override
  State<ChatTabs> createState() => _ChatTabsState();
}

class _ChatTabsState extends State<ChatTabs> {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    _tabController = DefaultTabController.of(context)!;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: List.generate(
        tabsChats.length,
        (index) => Text(
          tabsChats[index],
          maxLines: 1,
        ),
      ),
      labelColor: GPColor.workPrimary,
      unselectedLabelColor: GPColor.contentSecondary,
      indicatorColor: GPColor.workPrimary,
      indicatorPadding: EdgeInsets.zero,
      labelStyle: textStyle(GPTypography.headingMedium),
      onTap: (visit) async {},
    );
  }
}
