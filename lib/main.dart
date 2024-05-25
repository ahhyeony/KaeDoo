import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaedoo/screen/main/tab/splash_screen.dart';
import 'common/data/preference/app_preferences.dart';
import 'package:kaedoo/data/mysql/connect_db.dart';
import 'package:kaedoo/screen/main/tab/login/login.dart';

void main() async {
  dbConnector();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: MaterialApp(
          home: SplashScreen(),
          routes: <String, WidgetBuilder> {
            '/home': (BuildContext context) => const LoginMain()
          }
      )),
  );
}