import 'package:english_learn/pages/auth_pages/login_page.dart';
import 'package:english_learn/service/forgat_password.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../const/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key, required this.mail}) : super(key: key);
  final String mail;
  @override
  Widget build(BuildContext context) {
    TextEditingController pass1 = TextEditingController();
    TextEditingController pass2 = TextEditingController();

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
                  "Yeni şifrenizi giriniz",
                  style: context.textTheme.labelMedium
                      ?.copyWith(color: Colors.black54),
                ),
              ),
              CustomTextField(
                isSec: true,

                // onSubmitted: (term) {
                //   myFocusNode1.unfocus();
                //   FocusScope.of(context).requestFocus(myFocusNode2);
                // },
                //    focusNode: myFocusNode1,
                controller: pass1,
                title: "Şifre",
              ),
              CustomTextField(
                isSec: true,
                // onSubmitted: (term) {
                //   myFocusNode1.unfocus();
                //   FocusScope.of(context).requestFocus(myFocusNode2);
                // },
                //    focusNode: myFocusNode1,
                controller: pass2,
                title: "Şifre Yeniden",
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: CustomButton(
                  // focusNode: myFocusNode3,
                  title: "Şifre Yenile",
                  onPressed: () {
                    newPasswordService(
                            mail, pass1.text, pass2.text)
                        .then((value) {
                      if (value == 200) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          title: "Başarılı",
                          text: "Şifreniz yenilendi giriş yapabilirsiniz.",
                          confirmBtnText: "Tamam",
                          onConfirmBtnTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (route) => false),
                        );
                      } else {
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "Başarısız",
                            text: "Yeniden deneyin");
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
