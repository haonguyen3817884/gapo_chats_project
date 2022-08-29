import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:base_flutter/models/token/token_manager.dart';
import 'package:base_flutter/theme/themes.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:base_flutter/utils/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'generated/locales.g.dart';
import 'routes/routes.dart';

void main() async {
  await GetStorage.init();
  loadCache();
  runApp(const MyApp());
  configLoading();
}

void loadCache() {
  if (TokenManager.isLoggedIn()) {
    TokenManager.getCachedUserInfo();
    TokenManager.getNewUserInfo();
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        hideFooterWhenNotFull: true,
        child: GetMaterialApp(
          theme: AppThemes.theme(),
          darkTheme: AppThemes.darktheme(),
          themeMode: AppThemes().init(),
          locale: const Locale("en"),
          fallbackLocale: const Locale("en"),
          supportedLocales: const [
            Locale('vi'),
            Locale('en'),
          ],
          // `localizationsDelegates` transfer locale to child widgets, suchas datetime picker
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          translationsKeys: AppTranslation.translations,
          initialRoute: RouterName.chats,
          debugShowCheckedModeBanner: false,
          getPages: Pages.pages,
          routingCallback: (value) {
            if (value == null ||
                value.isBottomSheet == true ||
                value.isDialog == true) return;
            Utils.trackScreen(value.current);
          },
          builder: EasyLoading.init(),
        ));
  }
}
