// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/model/match_model.dart';
import 'package:english_learn/pages/bottom_bar_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../../../const/const.dart';
import 'onevsone_page.dart';

Future<void> isActiveService(String icAtive) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUserActive"),
    body: {"apiToken": apiToken, "userID": configID, "isActive": icAtive},
  );
  if (response.statusCode == 200) {
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

@override
class MatchPage extends StatefulWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  Timer? _timer;

  Future<MatchModel> matchService(BuildContext context) async {
    await isActiveService("1");
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getMatch"),
      body: {"apiToken": apiToken, "userID": configID, "isActive": "1"},
    );
    if (response.statusCode == 200) {
      var model = MatchModel.fromJson(jsonDecode(response.body));
      if (model.response?.isActive == "1") {
        _timer?.cancel();
        context.navigateToPage(OneLoad(
          enemyName: model.response?.name ?? "Veri Yok",
          enemyId: model.response?.id ?? "0",
        ));
      }
      return model;
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  @override
  void initState() {
    super.initState();

    if (isPremium == 1)
      _timer = Timer.periodic(
          const Duration(seconds: 5), (Timer t) => matchService(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rakip Aranıyor'),
        ),
        body: isPremium == 1
            ? Center(child: LottieBuilder.asset("assets/json/match2.json"))
            : Center(
                child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: colorBlue,
                        borderRadius: context.lowBorderRadius),
                    child: Text(
                      "Abonelik Paketiniz veya Hediyeniz Bulunmamakta",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))));
  }
}
