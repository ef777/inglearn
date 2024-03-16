// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/const/const.dart';

import 'package:english_learn/model/message_list_model.dart';
import 'package:english_learn/model/user_model.dart';
import 'package:english_learn/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
// import '../../const/const.dart';
import '../bottom_bar_pages/home_page.dart';
import '../bottom_bar_pages/profile_pages/profil_page.dart';
import '../menu_pages/chat_page.dart';

Future<MessageModelList> messageListService() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getMessageWithReceiverID"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    return MessageModelList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text('Mesajlar'),
        ),
        body: FutureBuilder(
            future: messageListService(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: context.paddingNormal,
                  child: Column(
                    children: List.generate(
                        snapshot.data?.response?.length ?? 0,
                        (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: MessageContainer(
                                  message:
                                      snapshot.data?.response?[index].message ??
                                          "",
                                  senderId: snapshot
                                          .data?.response?[index].senderID ??
                                      "64"),
                            )),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
    required this.senderId,
    required this.message,
  });
  final String senderId;
  final String message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: userGetService(userID: senderId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: context.paddingLow,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: context.normalBorderRadius,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(.3))
                    ]),
                child: Row(
                  children: [
                    FrameWidget(
                      image: snapshot.data?.response?[0].img ??
                          "https://i.pinimg.com/originals/54/29/5e/54295ebfb8c4eb3e41e1dbd7f6ce7213.jpg",
                      frame: "assets/image/frame2.png",
                    ),
                    // ClipRRect(
                    //   borderRadius: context.lowBorderRadius,
                    //   child: Image.network(

                    //     height: 50,
                    //   ),
                    // ),
                    SizedBox(
                      width: context.width * .04,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data?.response?[0].name} ${snapshot.data?.response?[0].surname}",
                          style: context.textTheme.labelLarge,
                        ),
                        SizedBox(
                          height: context.height * .005,
                        ),
                        Text(message,
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: colorOrange)),
                      ],
                    ),
                    const Spacer(),
                    CustomButton(
                      height: 30,
                      width: 70,
                      title: "Aç",
                      onPressed: () {
                        context.navigateToPage(ChatScreen(
                          name: snapshot.data?.response?[0].name ?? "",
                          image: snapshot.data?.response?[0].img ??
                              "https://i.pinimg.com/originals/a7/e9/70/a7e9701d273ae96e2a05a1a28c206e61.jpg",
                          senderID: senderId,
                        ));
                      },
                    )
                  ],
                ));
          } else {
            return SizedBox.shrink();
          }
        });
  }
}
