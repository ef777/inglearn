// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:english_learn/model/gift_model.dart';
import 'package:english_learn/model/premium_model.dart';
import 'package:english_learn/model/user_model.dart';
import 'package:english_learn/pages/appbar_pages/friends_page.dart';
import 'package:english_learn/pages/menu_pages/fortune_wheel_page.dart';
import 'package:english_learn/pages/menu_pages/learn_page.dart';
import 'package:english_learn/pages/menu_pages/speak_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../const/const.dart';
import '../../service/spin_service.dart';
import '../appbar_pages/message_page.dart';
import '../menu_pages/test_page.dart';
import 'onevone_pages/match_page.dart';

Future<UserModel> userGetService({String? userID}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUsers"),
    body: {
      "apiToken": apiToken,
      "userID": userID ?? configID,
    },
  );

  if (response.statusCode == 200) {
    var model = UserModel.fromJson(jsonDecode(response.body));
    configLevel = model.response?[0].level ?? "a1";
    return model;
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<GiftModel?> giftService({String? userID}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUsersGift"),
    body: {
      "apiToken": apiToken,
      "userID": userID ?? configID,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    var model = GiftModel.fromJson(jsonDecode(response.body));
    return model;
  } else {}
  return null;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

int isPremium = 0;

class _HomePageState extends State<HomePage> {
  final _spin = SpinController();
  spin() async {
    spinQu = await _spin.getSpinCount();
  }

  Future<PremiumModel> getUserPremium({String? userID}) async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getUserPremium"),
      body: {
        "apiToken": apiToken,
        "user_id": userID,
      },
    );

    if (response.statusCode == 200) {
      var model = PremiumModel.fromJson(jsonDecode(response.body));
      isPremium = await model.isPremium ?? 0;
      print(response.body);
      setState(() {});
      return model;
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  @override
  void initState() {
    spin();
    getUserPremium(userID: configID);
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Vocopus"),
        actions: [
          IconButton(
              onPressed: () {
                context.navigateToPage(const MessagePage());
              },
              icon: SvgPicture.asset("assets/icons/icon_notifi.svg")),
          IconButton(
              onPressed: () {
                context.navigateToPage(const FriendsPage());
              },
              icon: SvgPicture.asset("assets/icons/icon_profile.svg"))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<UserModel>(
            future: userGetService(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: context.paddingLow,
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      Padding(
                        padding: context.verticalPaddingNormal,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Kategoriler",
                            style: context.textTheme.titleLarge,
                          ),
                        ),
                      ),
                      GridViewOlacak(),
                      InkWell(
                        onTap: () {
                          if (spinQu >= 2) {
                            QuickAlert.show(
                                confirmBtnText: "Tamam",
                                context: context,
                                type: QuickAlertType.info,
                                text:
                                    "Günde Sadece İki Kez Hediye Çarkını Çevirebilirsiniz");
                          } else {
                            context.navigateToPage(const SpinnerGame());
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            padding: context.paddingLow,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 190, 85, 1),
                                borderRadius: context.normalBorderRadius),
                            height: 52,
                            width: double.infinity,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: context.width * .02,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Hediye Çarkı",
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Text(
                                      "Çarkı çevir süpriz hediyeler kazan",
                                      style: context.textTheme.labelMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Image.asset("assets/image/img_gift.png"),
                                SizedBox(
                                  width: context.width * .04,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class GridViewOlacak extends StatelessWidget {
  const GridViewOlacak({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MenuCardWidget(
              onTap: () {
                giftService().then((value) {
                  {
                    if (isPremium == 1)
                      context.navigateToPage(LaernLoad(number: "10"));
                    if (int.parse(value?.response ?? "0") > 0)
                      context.navigateToPage(LaernLoad(
                        number: value?.response ?? "0",
                      ));
                    else {
                      QuickAlert.show(
                          confirmBtnText: "Tamam",
                          text:
                              "Abonelik Paketiniz veya Hediyeniz Bulunmamakta ",
                          title: "Başarısız",
                          context: context,
                          type: QuickAlertType.error);
                      // }
                    }
                  }
                });
                // if (isGift ?? false) {
                //   giftService()
                //       .then((value) => context.navigateToPage(LaernLoad(
                //             number: value ?? "0",
                //           )));
                // } else {
                //   if (isPremium == 1) {
                //     context.navigateToPage(LaernLoad(number: "10"));
                //   } else
                //     QuickAlert.show(
                //         confirmBtnText: "Tamam",
                //         text: "Abonelik Paketiniz veya Hediyeniz Bulunmamakta ",
                //         title: "Başarısız",
                //         context: context,
                //         type: QuickAlertType.error);
                // }
              },
              image: "assets/image/img_lean.png",
              title: "Öğren",
              desc: "Kelimeler ile pratik yap",
            ),
            MenuCardWidget(
              onTap: () {
                if (isPremium == 1)
                  context.navigateToPage(const TextLoad());
                else {
                  QuickAlert.show(
                      confirmBtnText: "Tamam",
                      text: "Abonelik Paketiniz veya Hediyeniz Bulunmamakta ",
                      title: "Başarısız",
                      context: context,
                      type: QuickAlertType.error);
                }
              },
              image: "assets/image/img_test.png",
              title: "Test Et",
              desc: "Bilgilerini pekiştir",
            ),
          ],
        ),
        SizedBox(
          height: context.width * .04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MenuCardWidget(
              onTap: () {
                if (isPremium == 1)
                  context.navigateToPage(const MatchPage());
                else {
                  QuickAlert.show(
                      confirmBtnText: "Tamam",
                      text: "Abonelik Paketiniz veya Hediyeniz Bulunmamakta ",
                      title: "Başarısız",
                      context: context,
                      type: QuickAlertType.error);
                }
              },
              image: "assets/image/img_lean.png",
              title: "Kelime Yarışması",
              desc: "1 V 1 Oyna ",
            ),
            Opacity(
              opacity: 0,
              child: MenuCardWidget(
                onTap: () {
                  // if (isPremium == 1)
                  //   context.navigateToPage(const SpeakPage());
                  // else {
                  //   QuickAlert.show(
                  //       confirmBtnText: "Tamam",
                  //       text: "Abonelik Paketiniz veya Hediyeniz Bulunmamakta ",
                  //       title: "Başarısız",
                  //       context: context,
                  //       type: QuickAlertType.error);
                  // }
                },
                image: "assets/image/img_speak.png",
                title: "Konuşma Grupları",
                desc: "Topluluğa katıl (Ücretli)",
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MenuCardWidget extends StatelessWidget {
  const MenuCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
    this.onTap,
  });
  final String image;
  final String title;
  final String desc;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width / 2.35,
        height: context.width / 2.1,
        padding: context.paddingNormal,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.lowBorderRadius,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  color: Colors.grey.withOpacity(.2))
            ]),
        child: Column(
          children: [
            Image.asset(image),
            SizedBox(
              height: context.height * .01,
            ),
            Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(fontSize: 14),
            ),
            SizedBox(
              height: context.height * .01,
            ),
            Text(
              desc,
              style: context.textTheme.bodyMedium
                  ?.copyWith(fontSize: 12, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingLow,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 190, 85, 1),
          borderRadius: context.normalBorderRadius),
      height: 97,
      width: double.infinity,
      child: Row(
        children: [
          const CustomCircleAvatar(),
          SizedBox(
            width: context.width * .04,
          ),
          const AvatarTitleWidget(),
          const Spacer(),
          Image.asset("assets/image/img_title.png"),
          SizedBox(
            width: context.width * .04,
          ),
        ],
      ),
    );
  }
}

class AvatarTitleWidget extends StatelessWidget {
  const AvatarTitleWidget({
    super.key,
    this.title,
    this.desc,
  });
  final String? title;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title ?? "League",
            style: context.textTheme.titleLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          desc ?? "Bilgini yarıştır",
          style: context.textTheme.labelMedium?.copyWith(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Color.fromARGB(97, 255, 255, 255), shape: BoxShape.circle),
      child: Container(
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        padding: const EdgeInsets.all(2),
        child: const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              "https://i.pinimg.com/originals/b8/58/c6/b858c60ab186d515feb6d44e51fcef16.jpg"),
        ),
      ),
    );
  }
}
