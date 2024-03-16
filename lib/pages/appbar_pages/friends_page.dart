// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/const/colors.dart';
import 'package:english_learn/model/user_model.dart';
import 'package:english_learn/pages/bottom_bar_pages/profile_pages/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

import '../../const/const.dart';
import '../../model/friend_add_model.dart';
import '../../model/friends_model.dart';
import '../bottom_bar_pages/home_page.dart';
import '../menu_pages/chat_page.dart';

Future<bool> addFridensService(String id) async {
  var res = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUserAddFriend"),
    body: {"apiToken": apiToken, "userID": id, "addUserFriendID": configID},
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

Future<void> fridensService({
  required String? userID,
  required String? proccess,
}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/resetUserAddFriend"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
      "friend1ID": configID,
      "friend2ID": userID,
      "proccess": proccess
    },
  );

  if (response.statusCode == 200) {
    // return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<FriednsModel> getFridensService() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUserFriends"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
    },
  );

  if (response.statusCode == 200) {
    return FriednsModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<void> inviteService({
  required String? userID,
}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUserInviter"),
    body: {"apiToken": apiToken, "userID": configID, "inviterID": userID},
  );

  if (response.statusCode == 200) {
    print(response.body);
    // return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<UserModel> searchService({
  String? name,
  String? surname,
  String? mail,
}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getUserDetail"),
    body: {
      "apiToken": apiToken,
      if (name != null) "name": name,
      if (surname != null) "surname": surname,
      if (mail != null) "email": mail
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

TextEditingController controller = TextEditingController();
String search = "";
bool _isSearching = false;

class _FriendsPageState extends State<FriendsPage> {
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
          title: const Text('Arkdaşlar'),
        ),
        body: FutureBuilder<UserModel>(
            future: userGetService(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: context.paddingNormal,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: controller,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _isSearching = false;
                              });
                            } else {
                              setState(() {
                                _isSearching = true;
                              });
                            }
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              labelText: "İsim İle Arama Yap..."),
                        ),
                        // TextField(
                        //   onChanged: (value) {
                        //     search = value;
                        //   },
                        //   controller: controller,
                        //   decoration: InputDecoration(
                        //       focusedBorder: OutlineInputBorder(
                        //           borderRadius: context.normalBorderRadius),
                        //       enabledBorder: OutlineInputBorder(
                        //           borderRadius: context.normalBorderRadius),
                        //       hintText: "İsim soyisim, mail ile ara"),
                        // ),
                        if (_isSearching)
                          FutureBuilder<UserModel>(
                            future: searchService(name: controller.text),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: List.generate(
                                      snapshot.data?.response?.length ?? 0,
                                      (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Container(
                                              padding: context.paddingLow,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: context
                                                      .normalBorderRadius,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        spreadRadius: 2,
                                                        blurRadius: 10,
                                                        color: Colors.grey
                                                            .withOpacity(.3))
                                                  ]),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      FrameWidget(
                                                          frame:
                                                              "assets/image/frame2.png",
                                                          image: snapshot
                                                                  .data
                                                                  ?.response?[
                                                                      index]
                                                                  .img ??
                                                              "https://i.pinimg.com/originals/b5/6c/c9/b56cc941a3e0b9e2cbd09c4584cf1c52.jpg"),
                                                      SizedBox(
                                                        width:
                                                            context.width * .04,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            " ${snapshot.data?.response?[index].name.toString()} ${snapshot.data?.response?[index].surname.toString()}",
                                                            style: context
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        context
                                                                            .normalBorderRadius),
                                                                backgroundColor:
                                                                    colorBlue,
                                                              ),
                                                              onPressed: () {
                                                                addFridensService(snapshot
                                                                            .data
                                                                            ?.response?[
                                                                                index]
                                                                            .id
                                                                            .toString() ??
                                                                        "")
                                                                    .then(
                                                                        (value) {
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
                                                                        title: "Arkadaşlık isteği gönderildi!",
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
                                                                        title: "Arkadaşlık isteği gönderilemedi !",
                                                                        context: context,
                                                                        type: QuickAlertType.error);
                                                                  }
                                                                });
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                  "İstek Gönder",
                                                                  style: context
                                                                      .textTheme
                                                                      .labelSmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              Colors.white),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ))),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                        if (!_isSearching)
                          snapshot.data!.response?[0].addFriendID == null
                              ? const SizedBox.shrink()
                              : FutureBuilder<UserModel>(
                                  future: userGetService(
                                      userID: snapshot
                                          .data!.response?[0].addFriendID),
                                  builder: (context, fridendSnapshot) {
                                    if (fridendSnapshot.hasData) {
                                      return Container(
                                        padding: context.paddingLow,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                context.normalBorderRadius,
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.grey
                                                      .withOpacity(.3))
                                            ]),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Arkadaşlık İsteği",
                                              style:
                                                  context.textTheme.bodyLarge,
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/image/img_test2.png"),
                                                SizedBox(
                                                  width: context.width * .04,
                                                ),
                                                Text(
                                                  fridendSnapshot.data
                                                          ?.response?[0].name
                                                          .toString() ??
                                                      "",
                                                  style: context
                                                      .textTheme.labelLarge,
                                                ),
                                                const Spacer(),
                                                Column(
                                                  children: [
                                                    CustomIconButton(
                                                      onTap: () async {
                                                        await fridensService(
                                                          proccess: "1",
                                                          userID:
                                                              fridendSnapshot
                                                                  .data
                                                                  ?.response?[0]
                                                                  .id,
                                                        );
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const FriendsPage()));
                                                      },
                                                      color: colorGreenAccent,
                                                      icon: Icons.check,
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    CustomIconButton(
                                                      onTap: () =>
                                                          fridensService(
                                                        proccess: "0",
                                                        userID: fridendSnapshot
                                                            .data!
                                                            .response?[0]
                                                            .addFriendID,
                                                      ),
                                                      color: colorRedAccent,
                                                      icon: Icons.close,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                          child: SizedBox.shrink());
                                    }
                                  },
                                ),
                        SizedBox(
                          height: context.height * .01,
                        ),
                        if (!_isSearching)
                          FutureBuilder<FriednsModel>(
                            future: getFridensService(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: List.generate(
                                      snapshot.data?.response?.length ?? 0,
                                      (index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: FriendsContainer(
                                                friendID: snapshot
                                                        .data
                                                        ?.response?[index]
                                                        .friend2 ??
                                                    "69"),
                                          )),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.color,
    this.onTap,
  });
  final IconData icon;
  final Color color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              spreadRadius: 2,
              blurRadius: 10,
              color: Colors.grey.withOpacity(.3))
        ], shape: BoxShape.circle, color: color),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class FriendsContainer extends StatelessWidget {
  const FriendsContainer({
    super.key,
    required this.friendID,
  });
  final String friendID;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: userGetService(userID: friendID),
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
                    snapshot.data?.response?[0].img == null
                        ? Image.asset("assets/image/img_test2.png")
                        : FrameWidget(
                            frame: "assets/image/frmae4.png",
                            image: snapshot.data?.response?[0].img ?? "",
                          ),
                    SizedBox(
                      width: context.width * .04,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data?.response?[0].name ?? "",
                          style: context.textTheme.labelLarge,
                        ),
                        SizedBox(
                          height: context.height * .005,
                        ),
                        Text("Puan:  ${snapshot.data?.response?[0].point}",
                            style: context.textTheme.labelMedium
                                ?.copyWith(color: colorOrange)),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        SizedBox(
                            height: 28,
                            width: 90,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: context.normalBorderRadius),
                                  backgroundColor: colorOrange,
                                ),
                                onPressed: () {
                                  inviteService(userID: friendID).then(
                                      (value) => QuickAlert.show(
                                          text: "Davet Gönderildi",
                                          title: "1 V 1 Giderek Oyuna Başlayın",
                                          context: context,
                                          type: QuickAlertType.success));
                                },
                                child: Center(
                                  child: Text(
                                    "Oyuna Çağır",
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                        SizedBox(
                          height: context.height * .005,
                        ),
                        SizedBox(
                            height: 28,
                            width: 90,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: context.normalBorderRadius),
                                  backgroundColor: colorBlue,
                                ),
                                onPressed: () {
                                  context.navigateToPage(ChatScreen(
                                    name:
                                        snapshot.data?.response?[0].name ?? "",
                                    image: snapshot.data?.response?[0].img ??
                                        "https://i.pinimg.com/originals/a7/e9/70/a7e9701d273ae96e2a05a1a28c206e61.jpg",
                                    senderID: friendID,
                                  ));
                                },
                                child: Center(
                                  child: Text(
                                    "Mesaj Gönder",
                                    style: context.textTheme.labelSmall
                                        ?.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                        // SizedBox(
                        //   height: context.height * .005,
                        // ),
                        // SizedBox(
                        //     height: 28,
                        //     width: 90,
                        //     child: ElevatedButton(
                        //         style: ElevatedButton.styleFrom(
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: context.normalBorderRadius),
                        //           backgroundColor: colorYellow,
                        //         ),
                        //         onPressed: () {},
                        //         child: Center(
                        //           child: Text(
                        //             "Arkadaş Çıkar",
                        //             style: context.textTheme.labelSmall
                        //                 ?.copyWith(color: Colors.white),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ))),
                      ],
                    )
                  ],
                ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
