import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:agree_n/app/theme/theme.dart';
import 'package:agree_n/generated/locales.g.dart';
import 'package:agree_n/app/routes/app_pages.dart';
import 'package:agree_n/app/constants/constants.dart';
import 'package:agree_n/app/utils/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(
      FirebaseHelper.firebaseMessagingBackgroundHandler);
  //
  await FirebaseHelper.initFirebase();
  //
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translationsKeys: AppTranslation.translations,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      supportedLocales: SUPPORTED_LOCALES,
      fallbackLocale: FALLBACK_LOCALE,
      locale: Get.deviceLocale,
      title: LocaleKeys.appTitle.tr,
      theme: appThemeData,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      navigatorObservers: <NavigatorObserver>[
        FirebaseAnalyticsObserver(analytics: _firebaseAnalytics),
      ],
    );
  }
}
