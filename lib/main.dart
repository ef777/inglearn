import 'package:csc_picker_i18n/i18n/country_localization.dart';
import 'package:english_learn/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock_exports.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       supportedLocales: [
                 Locale("tr"),

          Locale("en"),
        ],
          locale: Locale("en"),
        localizationsDelegates: [
          CscCountryLocalizations.delegate,
         GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        navigatorKey: Grock.navigationKey,
        scaffoldMessengerKey: Grock.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16)),
            hintStyle: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.black54),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16)),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16)),
          ),
          appBarTheme: AppBarTheme(
              color: Colors.transparent,
              elevation: 0,
              titleTextStyle: Theme.of(context).textTheme.titleLarge),
          primarySwatch: Colors.blue,
        ),
        // ignore: unrelated_type_equality_checks
        home: const SplashScreen());
  }
}
