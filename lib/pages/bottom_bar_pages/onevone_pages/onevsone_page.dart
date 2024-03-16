// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:async';
import 'dart:convert';

import 'package:english_learn/pages/bottom_bar_pages/onevone_pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';

import '../../../const/colors.dart';
import '../../../const/const.dart';
import 'package:http/http.dart' as http;

import '../../../model/test_model.dart';
import '../../../model/user_model.dart';
import '../../menu_pages/test_page.dart';
import '../quiz_page.dart';

class OneLoad extends StatefulWidget {
  const OneLoad({super.key, required this.enemyId, required this.enemyName});
  final String enemyId;
  final String enemyName;

  @override
  // ignore: library_private_types_in_public_api
  _OneLoadState createState() => _OneLoadState();
}

class _OneLoadState extends State<OneLoad> {
  bool _showInitialWidget = true;

  @override
  void initState() {
    super.initState();
    // 3 saniye (3000 milisaniye) sonra diğer ekrana yönlendirecek zamanlayıcıyı başlatın
    //isActiveService("0");
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
            ? const QuizLoadBody()
            : OneVsOnePage(
                enemyName: widget.enemyName,
                enemyId: widget.enemyId,
              ));
  }
}

class QuizLoadBody extends StatelessWidget {
  const QuizLoadBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset("assets/json/ques_load.json"),
          Center(
            child: Text(
              'Size uygun test yükleniyor ...',
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: colorBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class OneVsOnePage extends StatefulWidget {
  const OneVsOnePage({Key? key, required this.enemyId, required this.enemyName})
      : super(key: key);
  final String enemyId;
  final String enemyName;

  @override
  State<OneVsOnePage> createState() => _OneVsOnePageState();
}

class _OneVsOnePageState extends State<OneVsOnePage> {
  int _countdownSeconds = 60;
  double _progressValue = 1.0;
  late Timer _timer;
  int _selected = -1;
  int _selected2 = -1;
  int point = 0;
  int indexT = 1;
  int dogru = 0;
  String enemyName = "";

  Future<UserModel> setUserPoint(String points) async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/setUserLastPoint"),
      body: {"apiToken": apiToken, "userID": configID, "point": points},
    );

    if (response.statusCode == 200) {
      var model = UserModel.fromJson(jsonDecode(response.body));
      enemyName = model.response?[0].name ?? "Veri Yok";
      return model;
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
    quesService();
  }

  void startCountdown() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countdownSeconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            _countdownSeconds--;
            _progressValue = _countdownSeconds / 60;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  List? queizData;
  final PageController controller = PageController(initialPage: 0);
  Future<TestModel> quesService() async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getWordWar"),
      body: {"apiToken": apiToken, "level": configLevel},
    );
    if (response.statusCode == 200) {
      var model = TestModel.fromJson(jsonDecode(response.body));
      queizData = model.response;
      return model;
    } else {
      throw Exception('Kayıt Başarısız');
    }
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Test Et'),
      ),
      body: Padding(
        padding: context.paddingLow,
        child: queizData == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VsAvatar(
                        point: point.toString(),
                      ),
                      SizedBox(
                        width: 160,
                        child: Stack(
                          children: [
                            Positioned(
                                bottom: 0,
                                right: 26,
                                child: Container(
                                  height: 26,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      color: colorYellow,
                                      borderRadius: context.normalBorderRadius),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.enemyName,
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  )),
                                )),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: colorYellow, shape: BoxShape.circle),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: colorYellow,
                                  // ignore: prefer_const_constructors
                                  backgroundImage: NetworkImage(
                                      "https://i.pinimg.com/originals/b8/58/c6/b858c60ab186d515feb6d44e51fcef16.jpg"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     PuanWidgetContainer(title: point.toString()),
                  //     TitleContainer(
                  //       indexT: indexT,
                  //       count: snapshot.data?.response?.length ?? 0,
                  //     )
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 2),
                    child: Text(
                      'Geri sayım: $_countdownSeconds saniye',
                      style: context.textTheme.labelSmall,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6, top: 2),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(colorYellow),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                        controller: controller,
                        itemCount: queizData?.length,
                        itemBuilder: (context, index) {
                          indexT = index + 1;

                          var ansver = queizData?[index].correctAnsw;
                          List<Question> question = [
                            Question(
                                ques: queizData?[index].answer1 ?? "",
                                ansver: "answer_1"),
                            Question(
                                ques: queizData?[index].answer2 ?? "",
                                ansver: "answer_2"),
                            Question(
                                ques: queizData?[index].answer3 ?? "",
                                ansver: "answer_3"),
                            Question(
                                ques: queizData?[index].answer4 ?? "",
                                ansver: "answer_4"),
                            Question(
                                ques: queizData?[index].answer5 ?? "",
                                ansver: "answer_5"),
                            Question(
                                ques: queizData?[index].answer6 ?? "",
                                ansver: "answer_6"),
                          ];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnsverContainerWidget(
                                        colorText: _selected == 0
                                            ? Colors.white
                                            : _selected2 == 0
                                                ? Colors.white
                                                : Colors.black,
                                        color: _selected == 0
                                            ? colorGreenAccent
                                            : _selected2 == 0
                                                ? colorRedAccent
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (ansver == question[0].ansver) {
                                              _selected = 0;
                                              point = point + 10;
                                              dogru = dogru + 1;
                                            } else {
                                              _selected2 = 0;
                                            }
                                          });
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () async {
                                            if (index <
                                                (queizData?.length ?? 0) - 1) {
                                              controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                              setState(() {
                                                _selected = -1;
                                                _selected2 = -1;
                                              });
                                            } else {
                                              setUserPoint(point.toString());
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OneResulLoad(
                                                            enemyID:
                                                                widget.enemyId,
                                                            dogru: dogru
                                                                .toString(),
                                                            total: queizData
                                                                    ?.length
                                                                    .toString() ??
                                                                "1",
                                                            point: point
                                                                .toString()),
                                                  ),
                                                  (route) => false);
                                            }
                                          });
                                        },
                                        controller: controller,
                                        title: question[0].ques),
                                    AnsverContainerWidget(
                                        colorText: _selected == 1
                                            ? Colors.white
                                            : _selected2 == 1
                                                ? Colors.white
                                                : Colors.black,
                                        color: _selected == 1
                                            ? colorGreenAccent
                                            : _selected2 == 1
                                                ? colorRedAccent
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (ansver == question[1].ansver) {
                                              _selected = 1;
                                              point = point + 10;
                                              dogru = dogru + 1;
                                            } else {
                                              _selected2 = 1;
                                            }
                                          });
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () async {
                                            if (index <
                                                (queizData?.length ?? 0) - 1) {
                                              controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                              setState(() {
                                                _selected = -1;
                                                _selected2 = -1;
                                              });
                                            } else {
                                              setUserPoint(point.toString());
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OneResulLoad(
                                                            enemyID:
                                                                widget.enemyId,
                                                            dogru: dogru
                                                                .toString(),
                                                            total: queizData
                                                                    ?.length
                                                                    .toString() ??
                                                                "1",
                                                            point: point
                                                                .toString()),
                                                  ),
                                                  (route) => false);
                                            }
                                          });
                                        },
                                        controller: controller,
                                        title: question[1].ques),
                                  ],
                                ),
                                Center(
                                    child: AnsverContainerWidget(
                                        colorText: _selected == 2
                                            ? Colors.white
                                            : _selected2 == 2
                                                ? Colors.white
                                                : Colors.black,
                                        color: _selected == 2
                                            ? colorGreenAccent
                                            : _selected2 == 2
                                                ? colorRedAccent
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (ansver == question[2].ansver) {
                                              _selected = 2;
                                              point = point + 10;
                                              dogru = dogru + 1;
                                            } else {
                                              _selected2 = 2;
                                            }
                                            Timer(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                              setState(() {
                                                _selected = -1;
                                                _selected2 = -1;
                                              });
                                            });
                                          });
                                        },
                                        controller: controller,
                                        title: question[2].ques)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AnsverContainerWidget(
                                        colorText: _selected == 3
                                            ? Colors.white
                                            : _selected2 == 3
                                                ? Colors.white
                                                : Colors.black,
                                        color: _selected == 3
                                            ? colorGreenAccent
                                            : _selected2 == 3
                                                ? colorRedAccent
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (ansver == question[3].ansver) {
                                              _selected = 3;
                                              point = point + 10;
                                              dogru = dogru + 1;
                                            } else {
                                              _selected2 = 3;
                                            }
                                          });
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () async {
                                            if (index <
                                                (queizData?.length ?? 0) - 1) {
                                              controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                              setState(() {
                                                _selected = -1;
                                                _selected2 = -1;
                                              });
                                            } else {
                                              setUserPoint(point.toString());
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OneResulLoad(
                                                            enemyID:
                                                                widget.enemyId,
                                                            dogru: dogru
                                                                .toString(),
                                                            total: queizData
                                                                    ?.length
                                                                    .toString() ??
                                                                "1",
                                                            point: point
                                                                .toString()),
                                                  ),
                                                  (route) => false);
                                            }
                                          });
                                        },
                                        controller: controller,
                                        title: question[3].ques),
                                    AnsverContainerWidget(
                                        colorText: _selected == 4
                                            ? Colors.white
                                            : _selected2 == 4
                                                ? Colors.white
                                                : Colors.black,
                                        color: _selected == 4
                                            ? colorGreenAccent
                                            : _selected2 == 4
                                                ? colorRedAccent
                                                : Colors.white,
                                        onTap: () {
                                          setState(() {
                                            if (ansver == question[4].ansver) {
                                              _selected = 4;
                                              point = point + 10;
                                              dogru = dogru + 1;
                                            } else {
                                              _selected2 = 4;
                                            }
                                          });
                                          Timer(
                                              const Duration(milliseconds: 500),
                                              () async {
                                            if (index <
                                                (queizData?.length ?? 0) - 1) {
                                              controller.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease);
                                              setState(() {
                                                _selected = -1;
                                                _selected2 = -1;
                                              });
                                            } else {
                                              setUserPoint(point.toString());
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OneResulLoad(
                                                            enemyID:
                                                                widget.enemyId,
                                                            dogru: dogru
                                                                .toString(),
                                                            total: queizData
                                                                    ?.length
                                                                    .toString() ??
                                                                "1",
                                                            point: point
                                                                .toString()),
                                                  ),
                                                  (route) => false);
                                            }
                                          });
                                        },
                                        controller: controller,
                                        title: question[4].ques),
                                  ],
                                ),
                                AnsverContainerWidget(
                                    colorText: _selected == 5
                                        ? Colors.white
                                        : _selected2 == 5
                                            ? Colors.white
                                            : Colors.black,
                                    color: _selected == 5
                                        ? colorGreenAccent
                                        : _selected2 == 5
                                            ? colorRedAccent
                                            : Colors.white,
                                    onTap: () {
                                      setState(() {
                                        if (ansver == question[5].ansver) {
                                          _selected = 5;
                                          point = point + 10;
                                        } else {
                                          _selected2 = 5;
                                        }
                                      });
                                      Timer(const Duration(milliseconds: 500),
                                          () {
                                        if (index <
                                            (queizData?.length ?? 0) - 1) {
                                          controller.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.ease);
                                          setState(() {
                                            _selected = -1;
                                            _selected2 = -1;
                                          });
                                        } else {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OneResulLoad(
                                                        enemyID: widget.enemyId,
                                                        dogru: dogru.toString(),
                                                        total: queizData?.length
                                                                .toString() ??
                                                            "1",
                                                        point:
                                                            point.toString()),
                                              ),
                                              (route) => false);
                                        }
                                      });
                                    },
                                    controller: controller,
                                    title: question[5].ques),
                                SizedBox(
                                  height: context.height * 0.03,
                                ),
                                AnsverContainerWidget(
                                  controller: controller,
                                  onTap: () {},
                                  color: colorYellow,
                                  title: queizData?[index].word ?? "",
                                  colorText: Colors.white,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),

        // FutureBuilder<TestModel>(
        //     future: quesService(),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData &&
        //           0 < (snapshot.data!.response?.length ?? 0)) {
        //         return

        //         Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 VsAvatar(
        //                   point: point.toString(),
        //                 ),
        //                 SizedBox(
        //                   width: 160,
        //                   child: Stack(
        //                     children: [
        //                       Positioned(
        //                           bottom: 0,
        //                           right: 26,
        //                           child: Container(
        //                             height: 26,
        //                             width: 110,
        //                             decoration: BoxDecoration(
        //                                 color: colorYellow,
        //                                 borderRadius:
        //                                     context.normalBorderRadius),
        //                             child: Center(
        //                                 child: Padding(
        //                               padding: const EdgeInsets.only(left: 8),
        //                               child: Align(
        //                                 alignment: Alignment.centerLeft,
        //                                 child: Text(
        //                                   widget.enemyName,
        //                                   style: context.textTheme.bodyLarge
        //                                       ?.copyWith(color: Colors.white),
        //                                 ),
        //                               ),
        //                             )),
        //                           )),
        //                       Align(
        //                         alignment: Alignment.centerRight,
        //                         child: Container(
        //                           padding: const EdgeInsets.all(4),
        //                           decoration: BoxDecoration(
        //                               color: colorYellow,
        //                               shape: BoxShape.circle),
        //                           child: CircleAvatar(
        //                             radius: 30,
        //                             backgroundColor: colorYellow,
        //                             // ignore: prefer_const_constructors
        //                             backgroundImage: NetworkImage(
        //                                 "https://i.pinimg.com/originals/b8/58/c6/b858c60ab186d515feb6d44e51fcef16.jpg"),
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             // Row(
        //             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             //   children: [
        //             //     PuanWidgetContainer(title: point.toString()),
        //             //     TitleContainer(
        //             //       indexT: indexT,
        //             //       count: snapshot.data?.response?.length ?? 0,
        //             //     )
        //             //   ],
        //             // ),
        //             Padding(
        //               padding: const EdgeInsets.only(top: 12, bottom: 2),
        //               child: Text(
        //                 'Geri sayım: $_countdownSeconds saniye',
        //                 style: context.textTheme.labelSmall,
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(bottom: 6, top: 2),
        //               child: LinearProgressIndicator(
        //                 value: _progressValue,
        //                 backgroundColor: Colors.grey,
        //                 valueColor: AlwaysStoppedAnimation<Color>(colorYellow),
        //               ),
        //             ),
        //             Expanded(
        //               child: PageView.builder(
        //                   controller: controller,
        //                   itemCount: snapshot.data?.response?.length,
        //                   itemBuilder: (context, index) {
        //                     indexT = index + 1;

        //                     var ansver =
        //                        queizData?[index].correctAnsw;
        //                     List<Question> question = [
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer1 ??
        //                                   "",
        //                           ansver: "answer_1"),
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer2 ??
        //                                   "",
        //                           ansver: "answer_2"),
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer3 ??
        //                                   "",
        //                           ansver: "answer_3"),
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer4 ??
        //                                   "",
        //                           ansver: "answer_4"),
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer5 ??
        //                                   "",
        //                           ansver: "answer_5"),
        //                       Question(
        //                           ques:
        //                              queizData?[index].answer6 ??
        //                                   "",
        //                           ansver: "answer_6"),
        //                     ];
        //                     return Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Column(
        //                         children: [
        //                           Row(
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               AnsverContainerWidget(
        //                                   colorText: _selected == 0
        //                                       ? Colors.white
        //                                       : _selected2 == 0
        //                                           ? Colors.white
        //                                           : Colors.black,
        //                                   color: _selected == 0
        //                                       ? colorGreenAccent
        //                                       : _selected2 == 0
        //                                           ? colorRedAccent
        //                                           : Colors.white,
        //                                   onTap: () {
        //                                     setState(() {
        //                                       if (ansver ==
        //                                           question[0].ansver) {
        //                                         _selected = 0;
        //                                         point = point + 10;
        //                                         dogru = dogru + 1;
        //                                       } else {
        //                                         _selected2 = 0;
        //                                       }
        //                                     });
        //                                     Timer(
        //                                         const Duration(
        //                                             milliseconds: 500),
        //                                         () async {
        //                                       if (index <
        //                                           (snapshot.data?.response
        //                                                       ?.length ??
        //                                                   0) -
        //                                               1) {
        //                                         controller.nextPage(
        //                                             duration: const Duration(
        //                                                 milliseconds: 500),
        //                                             curve: Curves.ease);
        //                                         setState(() {
        //                                           _selected = -1;
        //                                           _selected2 = -1;
        //                                         });
        //                                       } else {
        //                                         setUserPoint(point.toString());
        //                                         Navigator.pushAndRemoveUntil(
        //                                             context,
        //                                             MaterialPageRoute(
        //                                               builder: (context) =>
        //                                                   OneResulLoad(
        //                                                       enemyID: widget
        //                                                           .enemyId,
        //                                                       dogru: dogru
        //                                                           .toString(),
        //                                                       total: snapshot
        //                                                               .data
        //                                                               ?.response
        //                                                               ?.length
        //                                                               .toString() ??
        //                                                           "1",
        //                                                       point: point
        //                                                           .toString()),
        //                                             ),
        //                                             (route) => false);
        //                                       }
        //                                     });
        //                                   },
        //                                   controller: controller,
        //                                   title: question[0].ques),
        //                               AnsverContainerWidget(
        //                                   colorText: _selected == 1
        //                                       ? Colors.white
        //                                       : _selected2 == 1
        //                                           ? Colors.white
        //                                           : Colors.black,
        //                                   color: _selected == 1
        //                                       ? colorGreenAccent
        //                                       : _selected2 == 1
        //                                           ? colorRedAccent
        //                                           : Colors.white,
        //                                   onTap: () {
        //                                     setState(() {
        //                                       if (ansver ==
        //                                           question[1].ansver) {
        //                                         _selected = 1;
        //                                         point = point + 10;
        //                                         dogru = dogru + 1;
        //                                       } else {
        //                                         _selected2 = 1;
        //                                       }
        //                                     });
        //                                     Timer(
        //                                         const Duration(
        //                                             milliseconds: 500),
        //                                         () async {
        //                                       if (index <
        //                                           (snapshot.data?.response
        //                                                       ?.length ??
        //                                                   0) -
        //                                               1) {
        //                                         controller.nextPage(
        //                                             duration: const Duration(
        //                                                 milliseconds: 500),
        //                                             curve: Curves.ease);
        //                                         setState(() {
        //                                           _selected = -1;
        //                                           _selected2 = -1;
        //                                         });
        //                                       } else {
        //                                         setUserPoint(point.toString());
        //                                         Navigator.pushAndRemoveUntil(
        //                                             context,
        //                                             MaterialPageRoute(
        //                                               builder: (context) =>
        //                                                   OneResulLoad(
        //                                                       enemyID: widget
        //                                                           .enemyId,
        //                                                       dogru: dogru
        //                                                           .toString(),
        //                                                       total: snapshot
        //                                                               .data
        //                                                               ?.response
        //                                                               ?.length
        //                                                               .toString() ??
        //                                                           "1",
        //                                                       point: point
        //                                                           .toString()),
        //                                             ),
        //                                             (route) => false);
        //                                       }
        //                                     });
        //                                   },
        //                                   controller: controller,
        //                                   title: question[1].ques),
        //                             ],
        //                           ),
        //                           Center(
        //                               child: AnsverContainerWidget(
        //                                   colorText: _selected == 2
        //                                       ? Colors.white
        //                                       : _selected2 == 2
        //                                           ? Colors.white
        //                                           : Colors.black,
        //                                   color: _selected == 2
        //                                       ? colorGreenAccent
        //                                       : _selected2 == 2
        //                                           ? colorRedAccent
        //                                           : Colors.white,
        //                                   onTap: () {
        //                                     setState(() {
        //                                       if (ansver ==
        //                                           question[2].ansver) {
        //                                         _selected = 2;
        //                                         point = point + 10;
        //                                         dogru = dogru + 1;
        //                                       } else {
        //                                         _selected2 = 2;
        //                                       }
        //                                       Timer(
        //                                           const Duration(
        //                                               milliseconds: 500), () {
        //                                         controller.nextPage(
        //                                             duration: const Duration(
        //                                                 milliseconds: 500),
        //                                             curve: Curves.ease);
        //                                         setState(() {
        //                                           _selected = -1;
        //                                           _selected2 = -1;
        //                                         });
        //                                       });
        //                                     });
        //                                   },
        //                                   controller: controller,
        //                                   title: question[2].ques)),
        //                           Row(
        //                             mainAxisAlignment:
        //                                 MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               AnsverContainerWidget(
        //                                   colorText: _selected == 3
        //                                       ? Colors.white
        //                                       : _selected2 == 3
        //                                           ? Colors.white
        //                                           : Colors.black,
        //                                   color: _selected == 3
        //                                       ? colorGreenAccent
        //                                       : _selected2 == 3
        //                                           ? colorRedAccent
        //                                           : Colors.white,
        //                                   onTap: () {
        //                                     setState(() {
        //                                       if (ansver ==
        //                                           question[3].ansver) {
        //                                         _selected = 3;
        //                                         point = point + 10;
        //                                         dogru = dogru + 1;
        //                                       } else {
        //                                         _selected2 = 3;
        //                                       }
        //                                     });
        //                                     Timer(
        //                                         const Duration(
        //                                             milliseconds: 500),
        //                                         () async {
        //                                       if (index <
        //                                           (snapshot.data?.response
        //                                                       ?.length ??
        //                                                   0) -
        //                                               1) {
        //                                         controller.nextPage(
        //                                             duration: const Duration(
        //                                                 milliseconds: 500),
        //                                             curve: Curves.ease);
        //                                         setState(() {
        //                                           _selected = -1;
        //                                           _selected2 = -1;
        //                                         });
        //                                       } else {
        //                                         setUserPoint(point.toString());
        //                                         Navigator.pushAndRemoveUntil(
        //                                             context,
        //                                             MaterialPageRoute(
        //                                               builder: (context) =>
        //                                                   OneResulLoad(
        //                                                       enemyID: widget
        //                                                           .enemyId,
        //                                                       dogru: dogru
        //                                                           .toString(),
        //                                                       total: snapshot
        //                                                               .data
        //                                                               ?.response
        //                                                               ?.length
        //                                                               .toString() ??
        //                                                           "1",
        //                                                       point: point
        //                                                           .toString()),
        //                                             ),
        //                                             (route) => false);
        //                                       }
        //                                     });
        //                                   },
        //                                   controller: controller,
        //                                   title: question[3].ques),
        //                               AnsverContainerWidget(
        //                                   colorText: _selected == 4
        //                                       ? Colors.white
        //                                       : _selected2 == 4
        //                                           ? Colors.white
        //                                           : Colors.black,
        //                                   color: _selected == 4
        //                                       ? colorGreenAccent
        //                                       : _selected2 == 4
        //                                           ? colorRedAccent
        //                                           : Colors.white,
        //                                   onTap: () {
        //                                     setState(() {
        //                                       if (ansver ==
        //                                           question[4].ansver) {
        //                                         _selected = 4;
        //                                         point = point + 10;
        //                                         dogru = dogru + 1;
        //                                       } else {
        //                                         _selected2 = 4;
        //                                       }
        //                                     });
        //                                     Timer(
        //                                         const Duration(
        //                                             milliseconds: 500),
        //                                         () async {
        //                                       if (index <
        //                                           (snapshot.data?.response
        //                                                       ?.length ??
        //                                                   0) -
        //                                               1) {
        //                                         controller.nextPage(
        //                                             duration: const Duration(
        //                                                 milliseconds: 500),
        //                                             curve: Curves.ease);
        //                                         setState(() {
        //                                           _selected = -1;
        //                                           _selected2 = -1;
        //                                         });
        //                                       } else {
        //                                         setUserPoint(point.toString());
        //                                         Navigator.pushAndRemoveUntil(
        //                                             context,
        //                                             MaterialPageRoute(
        //                                               builder: (context) =>
        //                                                   OneResulLoad(
        //                                                       enemyID: widget
        //                                                           .enemyId,
        //                                                       dogru: dogru
        //                                                           .toString(),
        //                                                       total: snapshot
        //                                                               .data
        //                                                               ?.response
        //                                                               ?.length
        //                                                               .toString() ??
        //                                                           "1",
        //                                                       point: point
        //                                                           .toString()),
        //                                             ),
        //                                             (route) => false);
        //                                       }
        //                                     });
        //                                   },
        //                                   controller: controller,
        //                                   title: question[4].ques),
        //                             ],
        //                           ),
        //                           AnsverContainerWidget(
        //                               colorText: _selected == 5
        //                                   ? Colors.white
        //                                   : _selected2 == 5
        //                                       ? Colors.white
        //                                       : Colors.black,
        //                               color: _selected == 5
        //                                   ? colorGreenAccent
        //                                   : _selected2 == 5
        //                                       ? colorRedAccent
        //                                       : Colors.white,
        //                               onTap: () {
        //                                 setState(() {
        //                                   if (ansver == question[5].ansver) {
        //                                     _selected = 5;
        //                                     point = point + 10;
        //                                   } else {
        //                                     _selected2 = 5;
        //                                   }
        //                                 });
        //                                 Timer(const Duration(milliseconds: 500),
        //                                     () {
        //                                   if (index <
        //                                       (snapshot.data?.response
        //                                                   ?.length ??
        //                                               0) -
        //                                           1) {
        //                                     controller.nextPage(
        //                                         duration: const Duration(
        //                                             milliseconds: 500),
        //                                         curve: Curves.ease);
        //                                     setState(() {
        //                                       _selected = -1;
        //                                       _selected2 = -1;
        //                                     });
        //                                   } else {
        //                                     Navigator.pushAndRemoveUntil(
        //                                         context,
        //                                         MaterialPageRoute(
        //                                           builder: (context) =>
        //                                               OneResulLoad(
        //                                                   enemyID:
        //                                                       widget.enemyId,
        //                                                   dogru:
        //                                                       dogru.toString(),
        //                                                   total: snapshot
        //                                                           .data
        //                                                           ?.response
        //                                                           ?.length
        //                                                           .toString() ??
        //                                                       "1",
        //                                                   point:
        //                                                       point.toString()),
        //                                         ),
        //                                         (route) => false);
        //                                   }
        //                                 });
        //                               },
        //                               controller: controller,
        //                               title: question[5].ques),
        //                           SizedBox(
        //                             height: context.height * 0.03,
        //                           ),
        //                           AnsverContainerWidget(
        //                             controller: controller,
        //                             onTap: () {},
        //                             color: colorYellow,
        //                             title:
        //                                queizData?[index].word ??
        //                                     "",
        //                             colorText: Colors.white,
        //                           ),
        //                         ],
        //                       ),
        //                     );
        //                   }),
        //             ),
        //           ],
        //         );

        //       } else {
        //         return const Center(child: CircularProgressIndicator());
        //       }
        //     }),
      ),
    );
  }
}

class VsAvatar extends StatelessWidget {
  const VsAvatar({
    super.key,
    required this.point,
  });
  final String point;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              left: 30,
              child: Container(
                height: 26,
                width: 110,
                decoration: BoxDecoration(
                    color: colorBlue, borderRadius: context.normalBorderRadius),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Puan : $point",
                    style: context.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
                )),
              )),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: colorBlue, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: colorBlue,
              // ignore: prefer_const_constructors
              backgroundImage: NetworkImage(
                  "https://i.pinimg.com/originals/b8/58/c6/b858c60ab186d515feb6d44e51fcef16.jpg"),
            ),
          ),
        ],
      ),
    );
  }
}
