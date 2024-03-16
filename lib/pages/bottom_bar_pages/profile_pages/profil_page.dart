// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages, unnecessary_null_comparison, unused_local_variable
import 'dart:io';
import 'package:english_learn/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:dio/dio.dart';
import 'package:english_learn/model/user_model.dart';
import 'package:english_learn/pages/auth_pages/login_page.dart';
import 'package:english_learn/pages/bottom_bar_pages/profile_pages/agreement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grock/grock.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:english_learn/const/colors.dart';
import 'package:english_learn/pages/bottom_bar_pages/profile_pages/pro_member_page.dart';
import 'package:english_learn/service/login_service.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../const/const.dart';
import '../home_page.dart';
import 'package:http/http.dart' as http;

import 'communication_view.dart';

String frameImage = "assets/image/frame3.png";
Color frameBgcolor = Colors.blueAccent;

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

bool light = true;
// Future<void> setAvatarService(File image) async {
//   var response = await http.MultipartRequest(
//       'POST', Uri.parse('https://YOUR_SERVER_ENDPOINT_HERE'));
//   response.files.add(
//     await http.MultipartFile.fromPath('file_field_name', _image!.path,
//         contentType: MediaType('image', 'jpeg')),
//     body: {"apiToken": apiToken, "userID": configID, "img": image},
//   );
//   print(response.body);
//   Map<String, dynamic> data = jsonDecode(response.body);

//   if (response.statusCode == 200) {
//     // return data;

//     (data["response"][0]["lastPoint"]);
//   } else {
//     throw Exception('Kayıt Başarısız');
//   }
// }

Future<void> requestNotificationPermissions() async {
  final PermissionStatus status = await Permission.notification.request();
  if (status.isGranted) {
    // Notification permissions granted
  } else if (status.isDenied) {
    // Notification permissions denied
  } else if (status.isPermanentlyDenied) {
    // Notification permissions permanently denied, open app settings
    await openAppSettings();
  }
}

Future<void> clearUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('userID');
  await prefs.remove('configLevel');
  await prefs.remove('login');
}

Future<void> getFrame() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  frameID = prefs.getString('frame') ?? "assets/image/frame2.png";
}

Future<void> setNameService({
  required String? name,
}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUser"),
    body: {"apiToken": apiToken, "userID": configID, "name": name},
  );

  if (response.statusCode == 200) {
    // return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

Future<void> saveFrame(
  String frame,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('frame', frame);
}

Future<void> sendDeveloperService({
  required String? message,
}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/messageCreate"),
    body: {
      "apiToken": apiToken,
      "userID": configID,
      "nameSurname": "name",
      "message": message,
      "email": "ile@ile.com",
      "tel": "5556667788"
    },
  );

  if (response.statusCode == 200) {
    // return UserModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class _ProfilPageState extends State<ProfilPage> {
  late File _image;
  final picker = ImagePicker();
  final dio = Dio();
  String name = "";
  String image = "";

  String message = "";

  final FocusNode _nameFocus = FocusNode();
  final InAppReview inAppReview = InAppReview.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  Future<void> _requestReview() async {
    if (await inAppReview.isAvailable()) {
      // inAppReview.openStoreListing(appStoreId: );
      // Platform puanlama hizmeti kullanılabilirse, puanlama isteğini gönderin.
      await inAppReview.requestReview();
    } else {
      // Platform puanlama hizmeti kullanılamıyorsa, uygulama mağazasına yönlendirin.
      // Bu kısımda platforma bağlı olarak uygulamanızın mağaza sayfasına yönlendirme işlemini gerçekleştirebilirsiniz.
      // Örneğin, Android'de Google Play'e ve iOS'ta App Store'a yönlendirebilirsiniz.
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {}
    });
    uploadImage().then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomBarPage(
            index: 4,
          ),
        ),
        (route) => false));
  }

  Future uploadImage() async {
    if (_image == null) return;

    String fileName = _image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "img": await MultipartFile.fromFile(_image.path, filename: fileName),
      "apiToken": apiToken,
      "userID": configID
    });

    try {
      var response = await dio.post('https://vocopus.com/api/v1/setUserAvatar',
          data: formData);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
          actions: [
            IconButton(
                onPressed: () {
                  clearUserInfo();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false);
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ))
          ],
        ),
        body: FutureBuilder<UserModel>(
            future: userGetService(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: context.paddingNormal,
                    child: Column(
                      children: [
                        AvatarWidget(
                          isProfile: true,
                          color: frameBgcolor,
                          desc:
                              "Puan: ${snapshot.data?.response?[0].point ?? ""}",
                          title: name != ""
                              ? name
                              : snapshot.data?.response?[0].name.toObject(),
                          frame: frameImage,
                          image: image != ""
                              ? image
                              : snapshot.data?.response?[0].img ??
                                  "https://i.pinimg.com/originals/30/fd/90/30fd902767844eb1c81e30ca1433408b.jpg",
                        ),
                        ProfileWidget(
                          onTap: () {
                            QuickAlert.show(
                                    onConfirmBtnTap: () async {
                                      setState(() {
                                        name = nameController.text;
                                      });

                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    },
                                    showCancelBtn: true,
                                    cancelBtnText: "İptal",
                                    text:
                                        "Yeni isminizi girerek eski isminizle değiştirebilirsiniz",
                                    title: "İsim Değiştir",
                                    confirmBtnText: "Değiştir",
                                    widget: Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: TextField(
                                        focusNode: _nameFocus,
                                        onChanged: (value) {
                                          name = value;
                                        },
                                        controller: nameController,
                                        decoration: InputDecoration(
                                          hintText: "Yeni isminiz yaz",
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.amber)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.amber)),
                                        ),
                                      ),
                                    ),
                                    context: context,
                                    type: QuickAlertType.custom)
                                .then((value) {
                              setNameService(name: name);
                              nameController.text = "";
                            });
                            // setNameService(name: nameController.text);
                            // nameController.text = "";
                          },
                          title: "İsim Değiştir",
                          icon: "assets/icons/icon_edit.svg",
                        ),
                        ProfileWidget(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) => InkWell(
                                    onTap: getImage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      height: 200,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Galeriden Resim Seç",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: getImage,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius: context
                                                          .normalBorderRadius,
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors
                                                                .blueGrey
                                                                .withOpacity(
                                                                    .1),
                                                            blurRadius: 20,
                                                            spreadRadius: 7)
                                                      ]),
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(35),
                                                        child: Image.asset(
                                                          "assets/image/video.jpeg",
                                                          height: 70,
                                                          width: 70,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Galeriden Resim Seç",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                          ),
                                                          const Text(
                                                              "Galeriden resim seçerek avatarını değiştir.")
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: "Resim Değiştir",
                          icon: "assets/icons/icon_user.svg",
                        ),
                        ProfileWidget(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) => Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    height: 500,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "Çervece Seç",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          AvatarWidget(
                                            color: Colors.blueAccent,
                                            desc: "Puan: 230",
                                            title: snapshot
                                                    .data?.response?[0].name ??
                                                "",
                                            frame: "assets/image/frame.png",
                                            image:
                                                'https://i.pinimg.com/originals/ea/72/2c/ea722cf62a0586e6406c7fdd105bf125.jpg',
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          AvatarWidget(
                                            color: Color.fromARGB(
                                                255, 78, 115, 123),
                                            desc: "Puan: 230",
                                            title: snapshot
                                                    .data?.response?[0].name ??
                                                "",
                                            frame: "assets/image/frame2.png",
                                            image:
                                                'https://i.pinimg.com/originals/ea/72/2c/ea722cf62a0586e6406c7fdd105bf125.jpg',
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          AvatarWidget(
                                            color: colorPurple,
                                            desc: "Puan: 230",
                                            title: snapshot
                                                    .data?.response?[0].name ??
                                                "",
                                            frame: "assets/image/frame3.png",
                                            image:
                                                'https://i.pinimg.com/originals/ea/72/2c/ea722cf62a0586e6406c7fdd105bf125.jpg',
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          AvatarWidget(
                                            color:
                                                Color.fromRGBO(255, 190, 85, 1),
                                            desc: "Puan: 230",
                                            title: snapshot
                                                    .data?.response?[0].name ??
                                                "",
                                            frame: "assets/image/frmae4.png",
                                            image:
                                                'https://i.pinimg.com/originals/ea/72/2c/ea722cf62a0586e6406c7fdd105bf125.jpg',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: "Çerçeve Seç",
                          icon: "assets/icons/icon_cer.svg",
                        ),
                        ProfileWidget(
                          onTap: () => QuickAlert.show(
                              text:
                                  "Bildirimleri açarak sana en güzel haberleri iletmemize izin vermiş olursun",
                              title: "Bildirim Ayarını Değiştir",
                              confirmBtnText: "Değiştir",
                              widget: Padding(
                                  padding: const EdgeInsets.only(top: 32),
                                  child: CustomButton(
                                    color: Colors.blueAccent,
                                    title: "Bildirim Ayarları",
                                    onPressed: () {
                                      requestNotificationPermissions();
                                    },
                                  )),
                              context: context,
                              type: QuickAlertType.loading),
                          title: "Uygulama Bildirimleri",
                          icon: "assets/icons/icon_notification.svg",
                        ),

                        ProfileWidget(
                          onTap: () {
                            context.navigateToPage(AgreementView());
                          },
                          title: "Sayfalar",
                          icon: "assets/icons/icon_ranking.svg",
                        ),
                        ProfileWidget(
                          onTap: () =>
                              context.navigateToPage(const CommunicationView()),
                          title: "İletişim Bilgileri",
                          icon: "assets/icons/icon_pro2.svg",
                        ),
                        ProfileWidget(
                          onTap: () {
                            _requestReview();
                            // if (Platform.isIOS) {
                            //   // App Store URL
                            //   launcgURL2(
                            //       'https://play.google.com/store/apps/details?id=com.vocopus.app');
                            // } else if (Platform.isAndroid) {
                            //   // Google Play Store URL
                            //   launcgURL2(
                            //       'https://play.google.com/store/apps/details?id=com.vocopus.app');
                            // }
                          },
                          title: "Uygulamayı Puanla",
                          icon: "assets/icons/icon_ranking.svg",
                        ),

                        ProfileWidget(
                          onTap: () {
                            QuickAlert.show(
                                    onConfirmBtnTap: () async {
                                      setState(() {
                                        message = messageController.text;
                                      });

                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        Navigator.pop(context);
                                      });
                                    },
                                    text:
                                        "Düşünce ve fikirlerinizi geliştiriciye gönderebilirsiniz",
                                    title: "Geliştiriciye Mesaj",
                                    showCancelBtn: true,
                                    cancelBtnText: "İptal",
                                    confirmBtnText: "Gönder",
                                    widget: Padding(
                                      padding: const EdgeInsets.only(top: 32),
                                      child: TextField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText: "Geliştiriciye mesaj yaz",
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.blueAccent)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors.blueAccent)),
                                        ),
                                      ),
                                    ),
                                    context: context,
                                    type: QuickAlertType.info)
                                .then((value) {
                              sendDeveloperService(message: message);
                              messageController.text = "";
                            });
                          },
                          title: "Geliştiriciye Mesaj",
                          icon: "assets/icons/icon_message.svg",
                        ),
                        ProfileWidget(
                          onTap: () => context.navigateToPage(ProMemberPage()),
                          title: "Pro Üyelik",
                          icon: "assets/icons/icon_pro2.svg",
                        ),
                        // Image.network(
                        //     snapshot.data?.response?[0].img.toString() ?? ""),
                        ProfileWidget(
                          onTap: () {
                            QuickAlert.show(
                                onConfirmBtnTap: () => Navigator.pop(context),
                                onCancelBtnTap: () => userRemove(),
                                cancelBtnText: "Evet",
                                text:
                                    "Hesabınızı Kalıcı Olarak Sileceksiniz Emin Misiniz ?",
                                showCancelBtn: true,
                                title: "Hesabınız Silinecek",
                                confirmBtnText: "İptal",
                                context: context,
                                type: QuickAlertType.error);
                          },
                          title: "Hesabı Sil",
                          icon: "assets/icons/icon_trash.svg",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                              "assets/image/logo_band_colored@3x.png"),
                        )
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

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({
    Key? key,
    required this.title,
    required this.desc,
    required this.frame,
    required this.image,
    required this.color,
    this.isProfile,
  }) : super(key: key);
  final String title;
  final String desc;
  final String frame;
  final String image;

  final Color color;
  final bool? isProfile;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isProfile ?? false) {
        } else {
          saveFrame(widget.frame);

          setState(() {
            frameBgcolor = widget.color;
            frameImage = widget.frame;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomBarPage(
                  index: 4,
                ),
              ),
              (route) => false);
        }
      },
      child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            padding: context.paddingLow,
            decoration: BoxDecoration(
                color: widget.color, borderRadius: context.normalBorderRadius),
            height: 80,
            width: double.infinity,
            child: Row(
              children: [
                FrameWidget(
                  image: widget.image,
                  frame: widget.frame,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
                AvatarTitleWidget(
                  title: widget.title,
                  desc: widget.desc,
                ),
                const Spacer(),
                Image.asset("assets/image/img_title.png"),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .04,
                ),
              ],
            ),
          )),
    );
  }
}

class FrameWidget extends StatelessWidget {
  const FrameWidget({
    super.key,
    required this.frame,
    required this.image,
  });
  final String frame;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(
      //     vertical: 10, horizontal: 0),
      decoration:
          BoxDecoration(image: DecorationImage(image: AssetImage(frame))),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 7),
        child: Image.network(
          image,
          height: 50,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
      //     ),,
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  final String title;
  final String icon;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 58,
          decoration: BoxDecoration(
              borderRadius: context.normalBorderRadius,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    spreadRadius: 3, blurRadius: 5, color: Colors.grey.shade300)
              ]),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              SvgPicture.asset(icon),
              const SizedBox(
                width: 20,
              ),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}

launcgURL2(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

class FriendsContainer extends StatelessWidget {
  const FriendsContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            Image.asset("assets/image/img_test2.png"),
            SizedBox(
              width: MediaQuery.of(context).size.width * .04,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Melisa Yıldırım",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .005,
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          width: 140,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.4),
                              borderRadius: context.lowBorderRadius),
                        ),
                        Container(
                          height: 8,
                          width: 30,
                          decoration: BoxDecoration(
                              color: colorYellow,
                              borderRadius: context.lowBorderRadius),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .01,
                    ),
                    Text("Lvl 1",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: colorOrange)),
                  ],
                ),
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
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Oyuna Çağır",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .005,
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
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Mesaj Gönder",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .005,
                ),
                SizedBox(
                    height: 28,
                    width: 90,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: context.normalBorderRadius),
                          backgroundColor: colorYellow,
                        ),
                        onPressed: () {},
                        child: Center(
                          child: Text(
                            "Arkadaş Çıkar",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))),
              ],
            )
          ],
        ));
  }
}
