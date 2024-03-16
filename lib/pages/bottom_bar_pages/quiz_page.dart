// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/widgets/custom_button.dart';

import '../../const/const.dart';
import '../../model/question_model.dart';
import '../menu_pages/result_page.dart';

class QuizLoad extends StatefulWidget {
  const QuizLoad({super.key});

  @override
  _QuizLoadState createState() => _QuizLoadState();
}

class _QuizLoadState extends State<QuizLoad> {
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
        body: _showInitialWidget ? const QuizLoadBody() : const QuizPage());
  }
}

class QuizLoadBody extends StatelessWidget {
  const QuizLoadBody({
    super.key,
    this.json,
    this.title,
  });
  final String? json;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset(json ?? "assets/json/ques_load.json"),
          SizedBox(
            height: context.height * 0.02,
          ),
          Center(
            child: Text(
              title ?? 'Size uygun sorular yükleniyor ...',
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: colorBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  String ques;
  String ansver;
  Question({
    required this.ques,
    required this.ansver,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

Future<QuestionModel> quesService() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getQueAnswWithLevel"),
    body: {"apiToken": apiToken, "level": configLevel},
  );
  if (response.statusCode == 200) {
    return QuestionModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

String selectedChoice = "";

class _QuizPageState extends State<QuizPage> {
  void onChoiceSelected(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  PageController controller = PageController();
  int puan = 0;
  Color answerColor = colorBlue; // Cevap rengi için değişken eklendi
  int dogru = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder<QuestionModel>(
              future: quesService(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int? quesQunt = snapshot.data?.response?.length;
                  return SizedBox(
                    height: context.height * .69,
                    width: double.infinity,
                    child: Stack(children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: context.paddingLow,
                          child: Container(
                            width: context.width,
                            height: context.height * .64,
                            decoration: BoxDecoration(
                                borderRadius: context.normalBorderRadius,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.grey.withOpacity(.2))
                                ]),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: context.height * .06,
                                ),
                                PuanWidget(
                                  puan: puan.toString(),
                                ),
                                SizedBox(
                                  height: context.height * .02,
                                ),
                                Expanded(
                                  child: PageView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: controller,
                                    itemCount: snapshot.data?.response?.length,
                                    itemBuilder: (context, index) {
                                      List<Question> question = [
                                        Question(
                                            ques: snapshot.data!
                                                    .response?[index].answer1 ??
                                                "",
                                            ansver: "answer_1"),
                                        Question(
                                            ques: snapshot.data!
                                                    .response?[index].answer2 ??
                                                "",
                                            ansver: "answer_2"),
                                        Question(
                                            ques: snapshot.data!
                                                    .response?[index].answer3 ??
                                                "",
                                            ansver: "answer_3"),
                                        Question(
                                            ques: snapshot.data!
                                                    .response?[index].answer4 ??
                                                "",
                                            ansver: "answer_4"),
                                      ];

                                      return Column(
                                        children: [
                                          Text(
                                            snapshot.data!.response?[index]
                                                    .question ??
                                                "",
                                            style: context.textTheme.titleLarge,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: context.height * .02,
                                          ),
                                          for (int i = 0; i < 4; i++)
                                            Column(
                                              children: [
                                                AnsverSelection(
                                                  answerColor2:
                                                      selectedChoice ==
                                                              question[i].ansver
                                                          ? Colors.white
                                                          : Colors.black,
                                                  onTap: () => onChoiceSelected(
                                                      question[i].ansver),
                                                  title: Text(
                                                    question[i].ques,
                                                    style: TextStyle(
                                                        color: selectedChoice ==
                                                                question[i]
                                                                    .ansver
                                                            ? Colors.white
                                                            : Colors.black),
                                                  ),
                                                  answerColor: selectedChoice ==
                                                          question[i].ansver
                                                      ? answerColor
                                                      : Colors.white,
                                                ),
                                                SizedBox(
                                                  height: context.height * .02,
                                                ),
                                              ],
                                            ),
                                          Padding(
                                            padding:
                                                context.horizontalPaddingMedium,
                                            child: CustomButton(
                                              title: "Cevapla",
                                              onPressed: () {
                                                if (quesQunt != null) {
                                                  if (selectedChoice ==
                                                      snapshot
                                                          .data
                                                          ?.response?[index]
                                                          .correctAnsw) {
                                                    setState(() {
                                                      puan = puan + 10;
                                                      dogru = dogru + 1;
                                                      answerColor =
                                                          colorGreenAccent;
                                                    });
                                                  } else {
                                                    answerColor = Colors.red;
                                                  }
                                                  if (quesQunt! > 0) {
                                                    setState(() {
                                                      quesQunt =
                                                          (quesQunt! - 1);
                                                    });

                                                    Timer(
                                                        const Duration(
                                                            milliseconds: 500),
                                                        () {
                                                      if (index <
                                                          (snapshot
                                                                      .data
                                                                      ?.response
                                                                      ?.length ??
                                                                  0) -
                                                              1) {
                                                        controller.nextPage(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            curve: Curves.ease);
                                                        setState(() {
                                                          answerColor =
                                                              colorBlue;
                                                        });
                                                      } else {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => ResultPage(
                                                                      dogru: dogru
                                                                          .toString(),
                                                                      total: snapshot
                                                                              .data
                                                                              ?.response
                                                                              ?.length
                                                                              .toString() ??
                                                                          "1",
                                                                      point: puan
                                                                          .toString()),
                                                                ),
                                                                (route) =>
                                                                    false);
                                                      }
                                                    });
                                                  }
                                                } else {}
                                                // controller.nextPage(
                                                //     duration: const Duration(
                                                //         milliseconds: 500),
                                                //     curve: Curves.ease);
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      QuesitonCountWidget(
                        qustQunt: quesQunt ?? 0,
                      ),
                    ]),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }
}

class AnsverSelection extends StatelessWidget {
  const AnsverSelection({
    super.key,
    required this.title,
    this.onTap,
    required this.answerColor,
    required this.answerColor2, // answerColor parametresi eklendi
  });
  final Widget title;
  final Function()? onTap;
  final Color answerColor; // answerColor değişkeni eklendi
  final Color answerColor2; // answerColor değişkeni eklendi

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: context.horizontalPaddingMedium,
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: context.normalBorderRadius,
              border: Border.all(width: 2, color: answerColor2),
              color: answerColor), // Cevap rengine göre arkaplan rengi atanıyor
          child: Center(child: title),
        ),
      ),
    );
  }
}

class QuesitonCountWidget extends StatelessWidget {
  const QuesitonCountWidget({
    super.key,
    required this.qustQunt,
  });
  final int qustQunt;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: colorOrange)),
        child: Center(
            child: Text(
          qustQunt.toString(),
          style: context.textTheme.titleLarge,
        )),
      ),
    );
  }
}

class PuanWidget extends StatelessWidget {
  const PuanWidget({
    super.key,
    required this.puan,
  });
  final String puan;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 111,
      height: 35,
      decoration: BoxDecoration(
          color: colorYellow,
          borderRadius: context.normalBorderRadius,
          boxShadow: [
            BoxShadow(
                spreadRadius: 2,
                blurRadius: 10,
                color: Colors.grey.withOpacity(.2))
          ]),
      child: Center(
        child: Text("Puan: $puan",
            style:
                context.textTheme.titleMedium?.copyWith(color: Colors.white)),
      ),
    );
  }
}
