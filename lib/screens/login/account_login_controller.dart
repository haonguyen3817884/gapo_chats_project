// ignore_for_file: avoid_print, non_constant_identifier_names, curly_braces_in_flow_control_structures, unused_local_variable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:base_flutter/base/controller/base_controller.dart';
import 'package:base_flutter/base/networking/services/auth_api.dart';
import 'package:base_flutter/models/api/user_info.dart';
import 'package:base_flutter/models/token/token_manager.dart';
import 'package:base_flutter/routes/router_name.dart';
import 'package:base_flutter/utils/log.dart';
import 'package:base_flutter/utils/string_utils.dart';

class AccountLoginController extends BaseController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthAPI _api = AuthAPI();

  RxBool isLoginButtonEnabled = false.obs;
  RxBool isSecuredPassword = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    _binding();
  }

  void togglePasswordSecure() {
    isSecuredPassword.value = !isSecuredPassword.value;
  }

  void _binding() {
    emailController.addListener(() {
      print("change email " +
          emailController.text +
          " " +
          passwordController.text);
      _checkLoginEnable();
    });
    passwordController.addListener(() {
      print("change password " +
          emailController.text +
          " " +
          passwordController.text);
      _checkLoginEnable();
    });
  }

  void _checkLoginEnable() {
    bool validEmail = emailController.text.trim().isNotEmpty &&
        emailController.text.isValidEmail();
    isLoginButtonEnabled.value =
        validEmail && passwordController.text.trim().isNotEmpty;
  }

  void onLogin() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      var response = await _api.loginWithPassword(
          emailController.text, passwordController.text);
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
      TokenManager.saveUser(userInfo);
      Get.offNamed(RouterName.tabbar);
    } catch (error) {
      logDebug("get user error $error");
      handleError(error);
    }
  }

  void showVerificationLogin() {
    Get.toNamed(RouterName.login);
  }
}
