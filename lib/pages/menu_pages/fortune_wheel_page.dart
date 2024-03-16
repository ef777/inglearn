// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/bottom_bar_pages.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';

import '../../const/const.dart';
import '../../model/set_gift_model.dart';
import '../../model/spin_model.dart';
import '../../service/spin_service.dart';

Future<SetGiftModel> setGiftService(String giftId) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUserGift"),
    body: {"apiToken": apiToken, "giftID": giftId, "userID": configID},
  );
  print(response.body);
  if (response.statusCode == 200) {
    return SetGiftModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class SpinnerGame extends StatefulWidget {
  const SpinnerGame({super.key});

  @override
  _SpinnerGameState createState() => _SpinnerGameState();
}

class _SpinnerGameState extends State<SpinnerGame>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late String prizeNumber;
  SpinModel? model;
  final _spin = SpinController();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // çarkın dönme süresi
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Hediye Çarkı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              "assets/image/img_gift2.png",
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: context.height * .02,
            ),
            Text(
              "Hediye Çarkını Çevir",
              style: context.textTheme.titleLarge,
            ),
            SizedBox(
              height: context.height * .01,
            ),
            Text(
              "HEDİYE ÇARKINI ÇEVİREREK HER GÜN 100+ KELİMEYİ ÜCRETSİZ ÖĞRENEBİLİRSİN!",
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            // model == null
            //     ? AnimatedBuilder(
            //         animation: controller,
            //         child: LottieBuilder.asset(
            //             'assets/json/spin.json'), // çarkınızın resmi
            //         builder: (context, _widget) {
            //           return Transform.rotate(
            //             angle: controller.value * 6.28,
            //             child: _widget,
            //           );
            //         })
            //     : Text(model?.response?.title.toString() ?? ""),
            Expanded(
              child: FutureBuilder<SpinModel>(
                future: getPrizeNumber(), // bu fonksiyon servisten sonucu alır
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AnimatedBuilder(
                        animation: controller,
                        child: LottieBuilder.asset(
                            'assets/json/spin.json'), // çarkınızın resmi
                        builder: (context, widget) {
                          return Transform.rotate(
                            angle: controller.value * 6.28,
                            child: widget,
                          );
                        });
                  } else {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      prizeNumber = snapshot.data?.response?.title ?? "";

                      // sonucu prizeNumber'a ata
                      return const SizedBox.shrink();
                    }
                  }
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CustomButton(
            //     color: colorOrange,
            //     title: "Çarkı Çevir",
            //     onPressed: () async {
            //       model = await getPrizeNumber();
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 72,
            )
          ],
        ),
      ),
    );
  }

  Future<SpinModel> getPrizeNumber() async {
    await Future.delayed(const Duration(seconds: 5));

    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/startWheel"),
      body: {
        "apiToken": apiToken,
      },
    );
    if (response.statusCode == 200) {
      var model = SpinModel.fromJson(jsonDecode(response.body));
      // ignore: use_build_context_synchronously
      _spin.increaseSpinCount();
      QuickAlert.show(
          onConfirmBtnTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomBarPage(),
              ),
              (route) => false),
          confirmBtnText: "Tamam",
          context: context,
          type: QuickAlertType.success,
          title: "Çark Çevrildi !!!",
          text: 'Ödül Kazanıldı : ${model.response?.title ?? ""} !');
      setGiftService(model.response?.id.toString() ?? "1");
      return model; // rastgele bir ödül numarası döndürülür
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }
}
