// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/model/leader_status_model.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../../const/const.dart';
import '../../model/friend_add_model.dart';
import 'home_page.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<User> users = [];
  Future<LeaderStatusModel> getStats() async {
    var res = await http.post(
      Uri.parse("https://vocopus.com/api/v1/getUsersWithPoint"),
      body: {
        "apiToken": apiToken,
      },
    );
    print(res.body);
    if (res.statusCode == 200) {
      return LeaderStatusModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Kayıt Başarısız');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
        ),
        body: FutureBuilder<LeaderStatusModel>(
            future: getStats(),
            builder: (context, snapshot) {
              print(snapshot.error);
              if (snapshot.hasData) {
                return Padding(
                    padding: context.paddingLow,
                    child: ListView.builder(
                      itemCount: snapshot.data?.users?.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: StatsCardWidget(
                                userID: snapshot.data?.users?[index].id
                                        .toString() ??
                                    "0",
                                txtcolor: Colors.white,
                                color: colorOrange,
                                title: snapshot.data?.users?[index].name ??
                                    "Veri Bulunamadı",
                                point: snapshot.data?.users?[index].point
                                        .toString() ??
                                    "0",
                                number: (index + 1).toString()),
                          );
                        } else if (index == 1) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: StatsCardWidget(
                                userID: snapshot.data?.users?[index].id
                                        .toString() ??
                                    "0",
                                txtcolor: Colors.white,
                                color: colorPurple,
                                title: snapshot.data?.users?[index].name ??
                                    "Veri Bulunamadı",
                                point: snapshot.data?.users?[index].point
                                        .toString() ??
                                    "Veri Bulunamadı",
                                number: (index + 1).toString()),
                          );
                        } else if (index == 2) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: StatsCardWidget(
                                userID: snapshot.data?.users?[index].id
                                        .toString() ??
                                    "0",
                                txtcolor: Colors.white,
                                color: colorBlue,
                                title: snapshot.data?.users?[index].name ??
                                    "Veri Bulunamadı",
                                point: snapshot.data?.users?[index].point
                                        .toString() ??
                                    "Veri Bulunamadı",
                                number: (index + 1).toString()),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: StatsCardWidget(
                                userID: snapshot.data?.users?[index].id
                                        .toString() ??
                                    "0",
                                txtcolor: Colors.black,
                                color: Colors.white,
                                title: snapshot.data?.users?[index].name ??
                                    "Veri Bulunamadı",
                                point: snapshot.data?.users?[index].point
                                        .toString() ??
                                    "Veri Bulunamadı",
                                number: (index + 1).toString()),
                          );
                        }
                      },
                    ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class StatsCardWidget extends StatelessWidget {
  const StatsCardWidget({
    super.key,
    required this.title,
    required this.point,
    required this.number,
    required this.color,
    required this.txtcolor,
    required this.userID,
  });
  final String title;
  final Color color;
  final Color txtcolor;
  final String userID;

  final String point;
  final String number;
  @override
  Widget build(BuildContext context) {
    Future<bool> addFridensService() async {
      var res = await http.post(
        Uri.parse("https://vocopus.com/api/v1/setUserAddFriend"),
        body: {
          "apiToken": apiToken,
          "userID": userID,
          "addUserFriendID": configID
        },
      );
      if (res.statusCode == 200) {
        var model = FriendAddModel.fromJson(jsonDecode(res.body));
        if (model.status == 200) {
          return true;
        }
        return false;
      } else {
        throw Exception('Kayıt Başarısız');
      }
    }

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (context, setState) => Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    height: 180,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Arkadaş Ekle",
                            style: context.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: context.normalBorderRadius,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.blueGrey.withOpacity(.1),
                                        blurRadius: 20,
                                        spreadRadius: 7)
                                  ]),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.asset(
                                      "assets/image/img_test.png",
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.width * 0.03,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  InkWell(
                                      onTap: () {
                                        addFridensService().then((value) {
                                          if (value) {
                                            QuickAlert.show(
                                                // onConfirmBtnTap: () => Navigator.pushAndRemoveUntil(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => const MyBottomBar(
                                                //         cameras: [],
                                                //       ),
                                                //     ),
                                                //     (route) => false),
                                                confirmBtnText: "Tamam",
                                                title:
                                                    "Arkadaşlık isteği gönderildi !",
                                                context: context,
                                                type: QuickAlertType.success);
                                          } else {
                                            QuickAlert.show(
                                                // onConfirmBtnTap: () => Navigator.pushAndRemoveUntil(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => const MyBottomBar(
                                                //         cameras: [],
                                                //       ),
                                                //     ),
                                                //     (route) => false),
                                                confirmBtnText: "Tamam",
                                                title:
                                                    "Arkadaşlık isteği gönderilemedi !",
                                                context: context,
                                                type: QuickAlertType.error);
                                          }
                                        });
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                              color: Color.fromARGB(
                                                  90, 68, 137, 255),
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                              Icons.arrow_forward_ios))),
                                  const SizedBox(
                                    width: 8,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape
                    .rectangle, // Matches the border radius of the rectangle

                color: color,
                borderRadius: BorderRadius.circular(20), // Border radius value
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.white54, //edited
                      spreadRadius: 4,
                      blurRadius: 10 //edited
                      )
                ]),
            child: Row(
              children: [
                const CustomCircleAvatar(),
                SizedBox(
                  width: context.width * .04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: context.textTheme.titleLarge?.copyWith(
                            color: txtcolor, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Puan:$point",
                          style: context.textTheme.labelMedium?.copyWith(
                            color: txtcolor,
                          ),
                        ),
                        // Text(
                        //   "Bilgini yarıştır",
                        //   style: context.textTheme.labelMedium?.copyWith(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: context.width * .04,
                ),
              ],
            ),
          ),
        ),

        // Container(
        //   padding: context.paddingLow,
        //   decoration: BoxDecoration(
        //     borderRadius: context.normalBorderRadius,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey,
        //         offset: Offset(0, 3), // Shadow position, (x, y)
        //         blurRadius: 6, // Spread radius of the shadow
        //         spreadRadius: 2, // Extent of the shadow in all directions
        //       ),
        //     ],
        //     color: color,
        //   ),
        //   width: double.infinity,
        //   child: Row(
        //     children: [
        //       const CustomCircleAvatar(),
        //       SizedBox(
        //         width: context.width * .04,
        //       ),
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Center(
        //             child: Text(
        //               title,
        //               style: context.textTheme.titleLarge?.copyWith(
        //                   color: txtcolor, fontWeight: FontWeight.w700),
        //             ),
        //           ),
        //           Row(
        //             children: [
        //               Text(
        //                 "Puan:$point",
        //                 style: context.textTheme.labelMedium?.copyWith(
        //                   color: txtcolor,
        //                 ),
        //               ),
        //               // Text(
        //               //   "Bilgini yarıştır",
        //               //   style: context.textTheme.labelMedium?.copyWith(
        //               //     color: Colors.white,
        //               //   ),
        //               // ),
        //             ],
        //           )
        //         ],
        //       ),
        //       const Spacer(),
        //       SizedBox(
        //         width: context.width * .04,
        //       ),
        //     ],
        //   ),
        // ),

        Positioned(
          right: -30,
          top: -10,
          child: Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
                color: const Color.fromARGB(47, 232, 232, 232),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
                child: Text(
              number,
              style: context.textTheme.titleLarge?.copyWith(
                  color: txtcolor, fontSize: 24, fontWeight: FontWeight.bold),
            )),
          ),
        )
      ],
    );
  }
}

class HalfEllipsePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(size.width, size.height / 2)
      ..arcToPoint(Offset(size.width, size.height / 2 * 3),
          radius: Radius.elliptical(size.width / 2, size.height / 2),
          clockwise: false)
      ..lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class User {
  final String id;
  final String name;
  final String surname;
  final String mail;
  final int? point;

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.mail,
    this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      mail: json['mail'],
      point: json['point'] != null ? int.tryParse(json['point']) : null,
    );
  }
}
