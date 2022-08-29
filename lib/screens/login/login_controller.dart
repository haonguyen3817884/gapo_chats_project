// ignore_for_file: avoid_print, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:base_flutter/base/controller/base_controller.dart';
import 'package:base_flutter/base/networking/services/auth_api.dart';
import 'package:base_flutter/configs/constants.dart';
import 'package:base_flutter/generated/locales.g.dart';
import 'package:base_flutter/models/api/user_info.dart';
import 'package:base_flutter/models/token/token_manager.dart';
import 'package:base_flutter/routes/router_name.dart';
import 'package:base_flutter/utils/log.dart';
import 'package:base_flutter/utils/popup.dart';
import 'package:base_flutter/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginController extends BaseController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();
  final AuthAPI _api = AuthAPI();

  RxBool isNextButtonEnabled = false.obs;
  RxBool sendCodeButtonEnabled = false.obs;
  RxInt remainTime = Constants.maxOTPTime.obs;

  @override
  void onClose() {
    usernameController.dispose();
    verificationCodeController.dispose();
  }

  @override
  void onInit() {
    super.onInit();

    _binding();
  }

  void _binding() {
    usernameController.addListener(() {
      print("change email " +
          usernameController.text +
          " " +
          verificationCodeController.text);
      bool validEmail = usernameController.text.trim().isNotEmpty &&
          usernameController.text.isValidEmail();
      sendCodeButtonEnabled.value = validEmail;
    });
    verificationCodeController.addListener(() {
      print("change code " +
          usernameController.text +
          " " +
          verificationCodeController.text);
      bool validEmail = usernameController.text.trim().isNotEmpty &&
          usernameController.text.isValidEmail();
      isNextButtonEnabled.value =
          validEmail && verificationCodeController.text.trim().isNotEmpty;
    });
  }

  void onLogin() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      var response = await _api.loginWithOtp(
          usernameController.text, verificationCodeController.text);
      if (response.accessToken.isNotEmpty) {
        await TokenManager.saveAccessToken(response.accessToken);
        // Get.off(RouterName.jumping);
        _getUserInfo();
      }
    } catch (error) {
      logDebug("login error $error");
      handleError(error);
    }
  }

  void _getUserInfo() async {
    try {
      UserInfo userInfo = await _api.getUserInfo();
      isLoading.value = false;
      if (!userInfo.isActivated()) {
        // Get.toNamed(RouterName.activationCode);
      } else {
        TokenManager.saveUser(userInfo);
        Get.offNamed(RouterName.tabbar);
      }
    } catch (error) {
      logDebug("get user error $error");
      handleError(error);
    }
  }

  void showAccountLoginScreen() async {
    Get.toNamed(RouterName.accountLogin);
    // Get.toNamed(RouterName.passcode,
    //     arguments: {"type": PasscodeType.checking});
  }

  void showActivationCodeScreen() {
    // Get.toNamed(RouterName.activationCode);
  }

  void showPrivacyAction() async {
    String url = Constants.policyUrl;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void showAgreementAction() async {
    String url = Constants.agreementUrl;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  void sendCodeAction() async {
    if (remainTime.value != Constants.maxOTPTime ||
        sendCodeButtonEnabled.value == false) return;
    _startTimer();
    try {
      var response = await _api.requestEmailOTP(usernameController.text);
      if (response) {
        Popup.instance.showSnackBar(
            message: LocaleKeys.login_sendCodeSuccess.tr,
            type: SnackbarType.success);
      } else {}
    } catch (error) {
      logDebug("get list error $error");
      handleError(error);
    }
  }

  void _startTimer() {
    Timer _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainTime.value == 1) {
        remainTime.value = Constants.maxOTPTime;
        timer.cancel();
      } else {
        remainTime.value = remainTime.value - 1;
      }
    });
  }
}
