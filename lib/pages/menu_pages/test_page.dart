// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:english_learn/pages/bottom_bar_pages/quiz_page.dart';
import 'package:english_learn/pages/menu_pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';

import 'package:english_learn/model/test_model.dart';
import 'package:english_learn/widgets/title_container.dart';

import '../../const/colors.dart';
import '../../const/const.dart';

class TextLoad extends StatefulWidget {
  const TextLoad({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TextLoadState createState() => _TextLoadState();
}

class _TextLoadState extends State<TextLoad> {
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
        body: _showInitialWidget ? const QuizLoadBody() : const TestPage());
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

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _countdownSeconds = 60;
  double _progressValue = 1.0;
  late Timer _timer;
  int _selected = -1;
  int _selected2 = -1;
  int point = 0;
  int indexT = 1;
  int dogru = 0;

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

  List<Response>? queizData;
  final PageController controller = PageController(initialPage: 0);
  Future<TestModel> quesService() async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getWordWar"),
      body: {"apiToken": apiToken, "level": configLevel},
    );
    if (response.statusCode == 200) {
      print(response.body);

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
        padding: const EdgeInsets.all(8.0),
        child: queizData == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PuanWidgetContainer(title: point.toString()),
                      TitleContainer(
                        indexT: indexT,
                        count: queizData?.length ?? 0,
                      )
                    ],
                  ),
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
                                                        ResultPage(
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
                                                        ResultPage(
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
                                                        ResultPage(
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
                                                        ResultPage(
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
                                          dogru = dogru + 1;
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
                                                builder: (context) => ResultPage(
                                                    dogru: dogru.toString(),
                                                    total: queizData?.length
                                                            .toString() ??
                                                        "1",
                                                    point: point.toString()),
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
      ),
    );
  }
}

class TestPageWidget extends StatelessWidget {
  const TestPageWidget({
    Key? key,
    required this.controller,
    required this.title6,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.word,
  }) : super(key: key);
  final PageController controller;
  final String title6, title1, title2, title3, title4, title5, word;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 0,
            child: AnsverContainerWidget(controller: controller, title: title1),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: AnsverContainerWidget(controller: controller, title: title2),
          ),
          Positioned(
            top: context.height / 10,
            left: context.width / 3,
            child: Center(
                child: AnsverContainerWidget(
                    controller: controller, title: title3)),
          ),
          Positioned(
            top: context.height / 4.5,
            left: 0,
            child: AnsverContainerWidget(controller: controller, title: title4),
          ),
          Positioned(
            top: context.height / 4.5,
            right: 0,
            child: AnsverContainerWidget(controller: controller, title: title5),
          ),
          Positioned(
            top: context.height / 3.4,
            left: context.width / 3,
            child: AnsverContainerWidget(controller: controller, title: title6),
          ),
          Positioned(
            top: context.height / 2.3,
            left: context.width / 3,
            child: AnsverContainerWidget(
              controller: controller,
              onTap: () {},
              color: colorYellow,
              title: word,
              colorText: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class AnsverContainerWidget extends StatefulWidget {
  const AnsverContainerWidget({
    Key? key,
    required this.title,
    this.onTap,
    this.color,
    this.colorText,
    required this.controller,
  }) : super(key: key);
  final String title;
  final Function()? onTap;
  final Color? color;
  final Color? colorText;
  final PageController controller;

  @override
  State<AnsverContainerWidget> createState() => _AnsverContainerWidgetState();
}

class _AnsverContainerWidgetState extends State<AnsverContainerWidget> {
  bool colorChange = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(55),
      onTap: widget.onTap ??
          () {
            widget.controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
            setState(() {
              colorChange = true;
            });
          },
      child: Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color ?? Colors.white,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 4,
                  color: Colors.grey.withOpacity(.3))
            ]),
        child: Center(
            child: Text(
          widget.title,
          style: context.textTheme.bodySmall
              ?.copyWith(fontWeight: FontWeight.w500, color: widget.colorText),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

class PuanWidgetContainer extends StatelessWidget {
  const PuanWidgetContainer({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 100,
      decoration: BoxDecoration(
          color: colorOrange, borderRadius: context.normalBorderRadius),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Puan:",
            style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          Text(
            title,
            style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      )),
    );
  }
}
