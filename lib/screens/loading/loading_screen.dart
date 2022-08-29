import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:base_flutter/models/token/token_manager.dart';
import 'package:base_flutter/routes/router_name.dart';
import 'package:base_flutter/theme/colors.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLogin();
    });
  }

  void _checkLogin() {
    if (TokenManager.isLoggedIn()) {
      TokenManager.getCachedUserInfo();
      Get.offNamed(RouterName.tabbar);
    } else {
      Get.offNamed(RouterName.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GPColor.bgPrimary,
      body: Center(child: Image.asset("assets/images/Logo1.png")),
    );
  }
}
