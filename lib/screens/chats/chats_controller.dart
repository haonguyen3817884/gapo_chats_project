import 'dart:async';

import 'package:base_flutter/base/controller/base_controller.dart';
import 'package:base_flutter/base/networking/services/chat_api.dart';
import 'package:base_flutter/configs/constants.dart';
import 'package:base_flutter/configs/path.dart';
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/models/api/chat.dart';
import 'package:base_flutter/routes/routes.dart';
import 'package:base_flutter/theme/colors.dart';
import 'package:base_flutter/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import "package:base_flutter/base/networking/services/customer_api.dart";
import "package:base_flutter/models/api/customer_login.dart";
import "package:base_flutter/models/api/customer_info.dart";
import "package:base_flutter/models/api/chat_message.dart";
import "package:base_flutter/models/api/chat_message_body.dart";
import "package:base_flutter/models/api/chat_thread.dart";
import "package:base_flutter/base/networking/services/mqtt_service.dart";

class ChatsController extends BaseController {
  final ChatAPI _chatAPI = ChatAPI();
  final CustomerApi _customerApi = CustomerApi();

  final MQTTService<ChatMessage> _mqttService =
      MQTTService(host: "staging-mqtt.gapowork.vn", port: 1883);

  RxList chats = [].obs;
  RxString error = "".obs;
  RxString token = "".obs;
  var customerInfo = CustomerInfo(id: 0, avatar: "", name: "", email: "").obs;
  var chatMessage = ChatMessage(
          body: MessageBody(text: ""), thread: Thread(id: null, name: ""))
      .obs;

  List<ChatModel> _chatsStored = [];

  List<ChatMessage> messageArr = [];

  String _currentKeyword = "";
  Timer? _debounceSearch;
  int _currentPage = 1;

  bool get firstPage => (_currentPage == 1);

  CustomerLogin _customerLogin = CustomerLogin(user_id: 0, access_token: "");

  @override
  void onClose() {
    if (_debounceSearch != null) {
      _debounceSearch!.cancel();
    }
    super.onClose();
  }

  @override
  void onInit() {
    token.listen((value) async {
      if (value != "") {
        isLoading.value = true;

        try {
          await _getChats();
          await _getCustomerInfo();
          await _getMQTT();
        } catch (e) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: GPColor.workPrimary,
            messageText: Text(
              LocaleKeys.chat_errorNotification.tr,
              style: textStyle(GPTypography.bodyMedium)?.merge(
                  const TextStyle(color: GPColor.contentInversePrimary)),
            ),
            duration: const Duration(seconds: 2),
          ));
        }
        isLoading.value = false;
      }
    });

    chatMessage.listen((value) async {
      await updateChats(value);

      messageArr.add(value);
    });

    initLogin();
    super.onInit();
  }

  void initChats() async {
    isLoading.value = true;
    await _getChats();
    isLoading.value = false;
  }

  void initLogin() async {
    isLoading.value = true;
    await _getToken();
    isLoading.value = false;
  }

  void initCustomerInfo() async {
    isLoading.value = true;
    await _getCustomerInfo();
    isLoading.value = false;
  }

  void initMQTT() async {
    isLoading.value = true;
    await _getMQTT();
    isLoading.value = false;
  }

  Future<void> _getChats() async {
    await Future.delayed(const Duration(seconds: 2));
    List<ChatModel> res = await _chatAPI.getChatsFromApi(
        page: _currentPage,
        token: token.value,
        user_id: _customerLogin.user_id,
        messages: messageArr);
    if (_currentKeyword.trim().isNotEmpty) {
      if (firstPage) {
        chats.value = res
            .where((element) => element.nameContains(keyword: _currentKeyword))
            .toList();
      } else {
        chats.addAll(res
            .where((element) => element.nameContains(keyword: _currentKeyword))
            .toList());
      }
    } else {
      if (firstPage) {
        chats.value = res;
        _chatsStored = res;
      } else {
        chats.addAll(res);
        _chatsStored.addAll(res);
      }
    }
  }

  Future<void> _getToken() async {
    await Future.delayed(Duration(seconds: 2));
    CustomerLogin response = await _customerApi.getCustomer();
    _customerLogin = response;
    token.value = response.access_token;
  }

  Future<void> _getCustomerInfo() async {
    await Future.delayed(Duration(seconds: 2));
    CustomerInfo response =
        await _customerApi.getCustomerInfo(_customerLogin.user_id, token.value);

    customerInfo.value = response;
  }

  Future<void> _getMQTT() async {
    _mqttService.setUsername = _customerLogin.user_id.toString();
    _mqttService.setPassword = "Bearer " + token.value;
    _mqttService.setTopic =
        "v3/" + _customerLogin.user_id.toString() + "/" + "#";

    _mqttService.onMessagePublishedAction = updateChatMessage;

    _mqttService.initializeMQTTClient();
    await _mqttService.connectMQTT();
  }

  Future<dynamic> onReload() async {
    _currentPage = 1;

    messageArr = [];

    await _getChats();
  }

  Future<dynamic> onLoadMore() async {
    _currentPage += 1;
    await _getChats();
  }

  void onchangeSearch({required String keyword}) {
    if (_debounceSearch?.isActive ?? false) {
      _debounceSearch?.cancel();
    }
    _debounceSearch = Timer(const Duration(milliseconds: 500), () {
      _searchByKeyword(keyword: keyword);
    });
  }

  void _searchByKeyword({required String keyword}) {
    if (keyword.trim().isEmpty) {
      chats.value = _chatsStored;
      return;
    }
    _currentKeyword = keyword;
    List<ChatModel> result = [];
    for (ChatModel chat in _chatsStored) {
      if (chat.nameContains(keyword: keyword)) {
        result.add(chat);
      }
    }
    chats.value = result;
    return;
  }

  void removeChat({required ChatModel chat}) {
    actionCanUndo(
        listItem: chats,
        chat: chat,
        undoMessage: LocaleKeys.chat_delete_success.tr,
        action: () {
          printInfo(info: "Call api remove chat");
        });
  }

  void storeConversation({required ChatModel chat}) {
    Get.back();
    actionCanUndo(
        listItem: chats,
        chat: chat,
        undoMessage: LocaleKeys.chat_store_success.tr,
        action: () {
          printInfo(info: "Call api store conversation");
        });
  }

  void updateChatMessage(ChatMessage message) {
    chatMessage.value = message;
  }

  Future<void> updateChats(ChatMessage message) async {
    ChatModel chatModel = await _chatAPI.getChatFromApi(
        threadId: message.thread.id!,
        token: _customerLogin.access_token,
        user_id: _customerLogin.user_id);

    chatModel.lastMessage?.body = message.body.text;

    List<ChatModel> chatArr = [];

    chatArr = List<ChatModel>.from(chats);

    int chatIndex = chats.indexWhere((chat) {
      return chat.id == chatModel.id;
    });

    if (chatIndex != -1) {
      chatArr.removeAt(chatIndex);
    }

    chats.value = List<ChatModel>.from([chatModel])..addAll(chatArr);
  }

  void goToStoredConversationScreen() async {
    Get.back();
    bool reloadChats = await Get.toNamed(RouterName.storedConversation);
    if (reloadChats) {
      _currentPage = 1;
      await _getChats();
    }
  }

  void goToSelectedConversationScreen(ChatModel chatModel) async {
    Get.back();
    bool reloadChats = await Get.toNamed(RouterName.selectedConversation,
        arguments: chatModel);
    if (reloadChats) {
      _currentPage = 1;
      await _getChats();
    }
  }

  static void actionCanUndo({
    required RxList listItem,
    required ChatModel chat,
    required String undoMessage,
    required Function action,
  }) async {
    final storedList = [];
    storedList.addAll(listItem);
    listItem.removeWhere((element) {
      if (element is ChatModel) {
        return chat.id == element.id;
      }
      return false;
    });
    await Get.closeCurrentSnackbar();
    _showSnackBarCanUndo(
        undoMessage: undoMessage,
        listItem: listItem,
        action: action,
        storedList: storedList);
  }

  static void _showSnackBarCanUndo({
    required undoMessage,
    required RxList listItem,
    required Function action,
    required dynamic storedList,
  }) {
    bool acted = false;
    Get.showSnackbar(GetSnackBar(
      backgroundColor: GPColor.bgInversePrimary,
      icon: SvgPicture.asset(AppPaths.iconDone),
      messageText: Text(
        undoMessage,
        style: textStyle(GPTypography.bodyMedium)?.merge(
          const TextStyle(color: GPColor.contentInversePrimary),
        ),
      ),
      duration: const Duration(seconds: Constants.restoreSnackDuration),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 14),
      mainButton: SizedBox(
        width: 98,
        child: Row(
          children: [
            Container(
              width: 1,
              height: 20,
              color: GPColor.functionAlwaysLightPrimary.withOpacity(0.3),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                acted = true;
                Get.closeCurrentSnackbar();
                listItem.value = storedList;
              },
              child: Text(
                LocaleKeys.chat_undo.tr,
                style: textStyle(GPTypography.headingSmall)?.merge(
                  const TextStyle(color: GPColor.functionAccentWorkSecondary),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      borderRadius: 8,
      snackPosition: SnackPosition.TOP,
    )).future.then((value) {
      if (!acted) {
        action();
      }
    });
  }
}
