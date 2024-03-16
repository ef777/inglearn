// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:english_learn/model/pointsModel.dart';
import 'package:english_learn/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;

import '../../const/const.dart';

Future<PointsModel> pointService(String points) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUserPoint"),
    body: {"apiToken": apiToken, "userID": configID, "point": points},
  );

  if (response.statusCode == 200) {
    return PointsModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<String?> userGetService(String enemyID) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUsers"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
    },
  );
  Map<String, dynamic> data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return (data["response"][0]["point"]);
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class ResultPage extends StatelessWidget {
  const ResultPage(
      {Key? key, required this.point, required this.total, required this.dogru})
      : super(key: key);
  final String point;
  final String total;
  final String dogru;
  @override
  Widget build(BuildContext context) {
    String yanlis = (int.parse(total) - int.parse(dogru)).toString();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: context.height * .76,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 4,
                          color: Colors.grey.withOpacity(.4))
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(255, 190, 85, 1),
                        Color.fromARGB(94, 255, 190, 85),
                      ],
                    ),
                  ),
                  height: context.height * .63,
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.height * .04,
                      ),
                      Text("Sonuç Ekranı",
                          style: context.textTheme.titleLarge
                              ?.copyWith(color: Colors.white)),
                      const SizedBox(
                        height: 80,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            CircularProgress(percentage: double.parse(point)),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: context.horizontalPaddingMedium,
                    child: Container(
                      height: context.height * 0.4,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: context.lowBorderRadius,
                        color: const Color.fromARGB(233, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 3,
                              blurRadius: 4,
                              color: Colors.grey.withOpacity(.4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResultWidget(
                            color: Colors.green,
                            title: "Doğru Sayısı",
                            desc: "$dogru Doğru",
                          ),
                          ResultWidget(
                            color: Colors.redAccent,
                            title: "Yanlış Sayısı",
                            desc: "$yanlis Yanlış",
                          ),
                          ResultWidget(
                            color: Colors.blueAccent,
                            title: "Toplam Puan",
                            desc: "$point Puan",
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                title: "Devam Et",
                                onPressed: () async {
                                  var points = await userGetService(configID);

                                  var totalPoint = int.parse(points ?? "0") +
                                      int.parse(point);
                                  await pointService(totalPoint.toString());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomBarPage(),
                                      ),
                                      (route) => false);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
