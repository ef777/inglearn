// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:english_learn/pages/auth_pages/login_page.dart';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../const/const.dart';
import 'bottom_bar_pages/profile_pages/profil_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loginKey();
  }

  void _loginKey() {
    Future.delayed(const Duration(seconds: 2), () async {
      await getUserInfo();
      await getFrame();

      _loginControll();
    });
  }

  Future<dynamic> _loginControll() {
    frameImage = frameID;
    if (login == "0") {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false);
    } else {
      return Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomBarPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(75, 33, 96, 1),
      body: Padding(
        padding: context.paddingHigh,
        child: Center(child: Image.asset("assets/image/logo333.png")),
      ),
    );
  }
}
