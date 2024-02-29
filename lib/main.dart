import 'dart:io';
import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaling/screen_scale_properties.dart';
import 'package:saudimerchantsiller/common/failed_widget.dart';
import 'package:saudimerchantsiller/generated/locale_keys.g.dart';
import 'package:saudimerchantsiller/repo/firebase_notifications.dart';
import 'package:saudimerchantsiller/view/nav_bar/view.dart';
import 'helper/rout.dart';
import 'helper/theme.dart';
import 'repo/firebase_notifications.dart';
import 'view/intro/splash.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  // SharedPreferences.setMockInitialValues({});//
  Prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  await lang.EasyLocalization.ensureInitialized();
  await GlobalNotification.getFcmToken();
  GlobalNotification().setUpFirebase();
  initKiwi();
  runApp(
    lang.EasyLocalization(
      path: 'assets/langs',
      saveLocale: true,
      startLocale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scale =
        ScreenScaleProperties(width: 375, height: 812, allowFontScaling: true);
    return MaterialApp(
      title: 'عرب فور مقدم خدمة',
      home: const SplashView(),
      theme: StylesApp.getLightTheme(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: FailedWidget(
              errType: 2,
              title: kDebugMode
                  ? errorDetails.exception.toString()
                  : LocaleKeys.Oups_Something_went_wrong.tr(),
              onTap: () => pushAndRemoveUntil(const NavBarView()),
            ),
          );
        };
        return MediaQuery(
          child: _Unfocus(child: Phoenix(child: child!)),
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: scale.scaleHeight),
        );
      },
    );
  }
}

class _Unfocus extends StatefulWidget {
  const _Unfocus({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  __UnfocusState createState() => __UnfocusState();
}

class __UnfocusState extends State<_Unfocus> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: widget.child,
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   }
// }
// ignore: non_constant_identifier_names
late SharedPreferences Prefs;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
