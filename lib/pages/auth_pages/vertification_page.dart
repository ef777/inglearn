import 'package:english_learn/pages/auth_pages/login_page.dart';
import 'package:english_learn/pages/auth_pages/new_password.dart';
import 'package:english_learn/service/forgat_password.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:quickalert/quickalert.dart';

import '../../const/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class VertificationPassword extends StatelessWidget {
  const VertificationPassword({Key? key, required this.mail}) : super(key: key);
  final String mail;
  @override
  Widget build(BuildContext context) {
    TextEditingController telControler = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
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
                  "Şifremi Unuttum",
                  style: context.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  "Mailinize gelen doğrulama kodunu giriniz",
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
                title: "Doğrulama Kodu",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: CustomButton(
                  // focusNode: myFocusNode3,
                  title: "Doğrulama Kodu",
                  onPressed: () {
                    vertificationService(
                      mail,
                      telControler.text,
                    ).then((value) {
                      print(value);
                      if (value == 200) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewPassword(mail: mail),
                            ));
                      } else {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "Başarısız",
                            text: "Kod Hatalı");
                      }
                    });
                  },
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
      height: context.height * .4,
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
