// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:english_learn/pages/bottom_bar_pages/onevone_pages/match_page.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../../bottom_bar_pages.dart';
import '../../../const/colors.dart';
import '../../../const/const.dart';
import '../../menu_pages/result_page.dart';

Future<void> resetPoingService() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/resetUserLastPoint"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
    },
  );

  if (response.statusCode == 200) {
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class OneResulLoad extends StatefulWidget {
  const OneResulLoad(
      {super.key,
      required this.point,
      required this.dogru,
      required this.total,
      required this.enemyID});
  final String point;
  final String dogru;
  final String total;
  final String enemyID;

  @override
  // ignore: library_private_types_in_public_api
  _OneResulLoadState createState() => _OneResulLoadState();
}

class _OneResulLoadState extends State<OneResulLoad> {
  bool _showInitialWidget = true;
  Future<Map<String, dynamic>> userGetService(String? userID) async {
    var response = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getUsers"),
      body: {
        "apiToken": apiToken,
        "userID": userID ?? configID,
      },
    );
    Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (double.parse(data["response"][0]["lastPoint"]) > 0) {
        _timer?.cancel();
      }
      return data;
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  Timer? _timer;

  @override
  initState() {
    super.initState();
    // 3 saniye (3000 milisaniye) sonra diğer ekrana yönlendirecek zamanlayıcıyı başlatın
    //isActiveService("0");
    _timer =
        Timer.periodic(const Duration(seconds: 5), (Timer t) => loadPage());
  }

  Future<void> loadPage() async {
    var userEnemy = await userGetService(widget.enemyID);
    bool isLoad = double.parse(userEnemy["response"][0]["lastPoint"]) > 0;
    if (isLoad) {
      setState(() {
        _showInitialWidget = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _showInitialWidget
            ? const QuizLoadBody()
            : ResultPageOne(
                dogru: widget.dogru,
                enemyID: widget.enemyID,
                total: widget.total,
                point: widget.point,
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
              'Diğer Oyuncunun Bitirmesi Bekleniyor',
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: colorBlue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> userGetService(String? userID) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUsers"),
    body: {
      "apiToken": apiToken,
      "userID": userID ?? configID,
    },
  );
  Map<String, dynamic> data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data;
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class ResultPageOne extends StatefulWidget {
  const ResultPageOne({
    Key? key,
    required this.point,
    required this.dogru,
    required this.total,
    required this.enemyID,
  }) : super(key: key);
  final String point;
  final String dogru;
  final String total;
  final String enemyID;

  @override
  State<ResultPageOne> createState() => _ResultPageOneState();
}

class _ResultPageOneState extends State<ResultPageOne> {
  @override
  void initState() {
    super.initState();
    isActiveService("0");
  }

  // ignore: prefer_typing_uninitialized_variables
  var myLastPoint;
  bool winner = false;
  bool winner2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
          future: userGetService(configID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var dogruCevap =
                  double.parse(snapshot.data?["response"][0]["lastPoint"]) ~/
                      10;
              var yanlisCevap =
                  (double.parse(widget.total) - dogruCevap).toInt();
              double totalPoint = double.parse(widget.total) * 10;
              var lastPoint = 100 *
                  double.parse(snapshot.data?["response"][0]["lastPoint"]) /
                  totalPoint;
              myLastPoint =
                  double.parse(snapshot.data?["response"][0]["lastPoint"]);
              return Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(255, 190, 85, 1),
                                Color.fromARGB(94, 255, 190, 85),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 160,
                              ),
                              Text("Senin Sonuç Ekranın",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgress(percentage: lastPoint),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(snapshot.data?["response"][0]["name"],
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Toplam Soru : ${widget.total}",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Doğru Sayısı : $dogruCevap",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("Yanlış Sayısı : $yanlisCevap",
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 85, 142, 255),
                                Color.fromARGB(94, 255, 190, 85),
                              ],
                            ),
                          ),
                          child: FutureBuilder<Map<String, dynamic>>(
                              future: userGetService(widget.enemyID),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data?["response"][0]
                                            ["lastPoint"] !=
                                        null) {
                                  var dogruCevap = double.parse(snapshot
                                          .data?["response"][0]["lastPoint"]) ~/
                                      10;
                                  var yanlisCevap =
                                      (double.parse(widget.total) - dogruCevap)
                                          .toInt();
                                  double totalPoint =
                                      double.parse(widget.total) * 10;
                                  var lastPoint = 100 *
                                      double.parse(snapshot.data?["response"][0]
                                          ["lastPoint"]) /
                                      totalPoint;
                                  winner = myLastPoint >
                                      double.parse(snapshot.data?["response"][0]
                                          ["lastPoint"]);
                                  winner2 = myLastPoint ==
                                      double.parse(snapshot.data?["response"][0]
                                          ["lastPoint"]);
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 160,
                                      ),
                                      Text("Rakip Sonuç Ekranı",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgress(
                                            percentage: lastPoint),
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                          snapshot.data?["response"][0]["name"],
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Toplam Soru : ${widget.total}",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Doğru Sayısı : $dogruCevap",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("Yanlış Sayısı : $yanlisCevap",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 160,
                    right: context.width / 5,
                    child: SizedBox(
                      width: 250,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: winner
                                  ? Colors.greenAccent
                                  : Colors.redAccent),
                          onPressed: () async {
                            var points = await userGetService(configID);
                            await resetPoingService();

                            var totalPoint = int.parse(
                                    points["response"][0]["point"] ?? "0") +
                                int.parse(widget.point);
                            await pointService(totalPoint.toString());
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BottomBarPage(),
                                ),
                                (route) => false);
                          },
                          child: Text(winner ? "Kazandın" : "Kaybettin")),
                    ),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.color,
  });
  final String title;
  final String desc;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: Colors.black54)),
          Text(desc,
              style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600, fontSize: 18, color: color)),
          Divider(
            thickness: 1,
            color: color,
          ),
        ],
      ),
    );
  }
}

var pi = 3.15;

class CircularProgress extends StatelessWidget {
  final double percentage;
  final Color progressColor;
  final double strokeWidth;

  const CircularProgress({
    super.key,
    required this.percentage,
    this.progressColor = Colors.white,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularProgressPainter(
        percentage: percentage,
        progressColor: progressColor,
        strokeWidth: strokeWidth,
      ),
      child: Center(
        child: Text(
          '${percentage.toInt()}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: progressColor,
          ),
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double percentage;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.percentage,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 5;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw background arc (yarım daire)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi,
      false,
      backgroundPaint,
    );

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      (percentage / 100) * pi,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
