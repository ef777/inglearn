import 'dart:async';
import 'dart:convert';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/model/learn_model.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../../const/const.dart';
import '../../widgets/learn_card_widget.dart';
import '../../widgets/title_container.dart';
import '../bottom_bar_pages/quiz_page.dart';

Future<void> updateUserWordsCountService(
    {String? userID, required String count}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/updateUserWordsCount"),
    body: {
      "apiToken": apiToken,
      "userId": configID,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
  } else {}
  return null;
}

class LaernLoad extends StatefulWidget {
  const LaernLoad({super.key, required this.number});
  final String number;
  @override
  // ignore: library_private_types_in_public_api
  _LaernLoadState createState() => _LaernLoadState();
}

class _LaernLoadState extends State<LaernLoad> {
  bool _showInitialWidget = true;

  @override
  void initState() {
    super.initState();
    // 3 saniye (3000 milisaniye) sonra diğer ekrana yönlendirecek zamanlayıcıyı başlatın
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _showInitialWidget = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _showInitialWidget
            ? const QuizLoadBody(
                title: "Kelimeler Yükleniyor ...",
                json: "assets/json/load3.json",
              )
            : LearnPage(
                number: widget.number,
              ));
  }
}

class LearnPage extends StatefulWidget {
  const LearnPage({Key? key, required this.number}) : super(key: key);
  final String number;
  @override
  State<LearnPage> createState() => _LearnPageState();
}

Future<LearnModel> learnService() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getLearnPages"),
    body: {
      "apiToken": apiToken,
    },
  );
  if (response.statusCode == 200) {
    var model = LearnModel.fromJson(jsonDecode(response.body));
    updateUserWordsCountService(
        count: model.response?.length.toString() ?? "0");
    return model;
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class _LearnPageState extends State<LearnPage> {
  int indexT = 1;

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Öğren'),
      ),
      body: FutureBuilder<LearnModel>(
        future: learnService(),
        builder: (context, snapshot) {
          int? lengtList;
          if (snapshot.data?.response?.isNotEmpty ?? false) {
            if (snapshot.data!.response!.length > int.parse(widget.number)) {
              lengtList = int.parse(widget.number);
            } else {
              lengtList = snapshot.data!.response!.length;
            }
          }

          if (snapshot.hasData) {
            return Padding(
                padding: context.paddingNormal,
                child: Column(
                  children: [
                    Center(
                      child:
                          TitleContainer(indexT: indexT, count: lengtList ?? 1),
                    ),
                    SizedBox(
                      height: context.height * .04,
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: controller,
                        itemCount: lengtList,
                        itemBuilder: (context, index) {
                          indexT = index + 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                LeanCardWidget(
                                    desc: snapshot
                                            .data?.response?[index].engDesc ??
                                        "Veri Bulunamadı",
                                    title: snapshot
                                            .data?.response?[index].engTitle ??
                                        "Veri Bulunamadı"),
                                SizedBox(
                                  height: context.height * .02,
                                ),
                                LeanCardWidget(
                                  desc:
                                      snapshot.data?.response?[index].trDesc ??
                                          "Veri Bulunamadı",
                                  title:
                                      snapshot.data?.response?[index].trTitle ??
                                          "Veri Bulunamadı",
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: context.paddingNormal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: colorBlue, shape: BoxShape.circle),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        indexT =
                                            (controller.page ?? 0 + 1).toInt();
                                      });
                                      controller.previousPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                              ),
                              SizedBox(
                                width: context.width * 0.02,
                              ),
                              const Text("Önceki")
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Sonraki"),
                              SizedBox(
                                width: context.width * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: colorBlue, shape: BoxShape.circle),
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        indexT =
                                            (controller.page ?? 0 + 1).toInt();
                                      });
                                      controller.nextPage(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
