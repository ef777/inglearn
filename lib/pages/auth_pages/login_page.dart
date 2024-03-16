import 'package:english_learn/pages/auth_pages/forgat_password.dart';
import 'package:english_learn/pages/auth_pages/register_page.dart';
import 'package:english_learn/service/login_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:quickalert/quickalert.dart';

import '../../bottom_bar_pages.dart';
import '../../const/colors.dart';
import '../../const/const.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  configID = prefs.getString('userID') ?? "1";
  configLevel = prefs.getString('configLevel') ?? "a1";
  configLevel = login = prefs.getString('login') ?? "0";
}

Future<void> saveUserInfo(
    String userID, String configLevel, String login) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('userID', userID);
  await prefs.setString('configLevel', configLevel);
  await prefs.setString('login', login);
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController telControler = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const RegisterImageWidget(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  "Hoş Geldiniz",
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  "Quizlere katıl, bilgini test et, yepyeni kelimeler öğren ve arkadaşlarınla pratikler yaparak kendini geliştir. Öğrenmenin eğlenceli yolunu keşfet",
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: Colors.black54),
                ),
              ),
              CustomTextField(
                // onSubmitted: (term) {
                //   myFocusNode1.unfocus();
                //   FocusScope.of(context).requestFocus(myFocusNode2);
                // },
                //    focusNode: myFocusNode1,
                controller: telControler,
                title: "Kullanıcı Adı",
              ),
              CustomTextField(
                // onSubmitted: (term) {
                //   myFocusNode1.unfocus();
                //   FocusScope.of(context).requestFocus(myFocusNode3);
                // },
                // focusNode: myFocusNode2,
                isSec: true,
                controller: passwordController,
                title: "Şifre",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: CustomButton(
                  // focusNode: myFocusNode3,
                  title: "Giriş Yap",
                  onPressed: () {
                    print(telControler.text);
                    print(passwordController.text);
                    loginService(telControler.text, passwordController.text)
                        .then((value) {
                      if (value.isLogin ?? false) {
                        configID = value.response?.id.toString() ?? "0";
                        saveUserInfo(value.response?.id.toString() ?? "0",
                            value.response?.level ?? "a1", "1");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BottomBarPage()));
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Başarısız",
                          text: "Giriş Yapılamadı",
                          confirmBtnText: "Tamam",
                        );
                      }
                    });
                  },
                ),
              ),
              Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgatPassword(),
                            ),
                            (route) => false);
                      },
                      child: Text("Şifremi unuttum"))),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Hala üye değil misin? O zaman ',
                          style: context.textTheme.labelSmall,
                        ),
                        TextSpan(
                          text: 'Kayıt Ol',
                          style: context.textTheme.labelMedium
                              ?.copyWith(color: colorOrange),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.navigateToPage(const RegisterPage());
                              // Butona tıklandığında yapılacak işlemler
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterImageWidget extends StatelessWidget {
  const RegisterImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: context.height * .32,
      child: Stack(
        children: [
          Positioned(
            left: -50,
            top: 40,
            child: Container(
              width: 96,
              height: 96,
              decoration:
                  BoxDecoration(color: colorBlue, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -100,
            top: 0,
            child: Container(
              width: 184,
              height: 184,
              decoration:
                  BoxDecoration(color: colorYellow, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: 20,
            top: 180,
            child: Container(
              width: 24,
              height: 24,
              decoration:
                  BoxDecoration(color: colorPurple, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: 30,
            top: 220,
            child: Container(
              width: 24,
              height: 24,
              decoration:
                  BoxDecoration(color: colorRedAccent, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: context.width / 2.5,
            bottom: 0,
            child: Container(
              width: 146,
              height: 146,
              decoration:
                  BoxDecoration(color: colorOrange, shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Image.asset(
              "assets/image/img_login.png",
              height: 280,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
