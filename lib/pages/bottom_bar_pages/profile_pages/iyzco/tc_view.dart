import 'dart:convert';

import 'package:english_learn/bottom_bar_pages.dart';
import 'package:english_learn/const/colors.dart';
import 'package:english_learn/const/const.dart';
import 'package:english_learn/pages/bottom_bar_pages/profile_pages/iyzco/webview.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:http/http.dart' as http;

class TCView extends StatelessWidget {
  const TCView({Key? key, required this.isSelected}) : super(key: key);
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomBarPage(),
                    ),
                    (route) => false),
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ))
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Ödeme Bilgileri"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TC KİMLİK NUMARASI",
                style: context.textTheme.bodyLarge,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 1, color: colorBlue)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 1, color: colorBlue))),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorBlue),
                        onPressed: () {
                          setUSerTC(controller.text).then((value) {
                            if (value.status == 200) {
                              context.navigateToPage(IyzcoWebView(
                                url:
                                    'https://vocopus.com/payments/packet_buy?id=$configID&packet_id=${isSelected ? 1 : 2}',
                              ));
                            }
                          });
                        },
                        child: const Text("Devam Et"))),
              ),
            ],
          ),
        ));
  }
}

Future<TCMODEL> setUSerTC(String points) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/setUser"),
    body: {"apiToken": apiToken, "userID": configID, "identifyNumber": points},
  );
  print(response.body);

  if (response.statusCode == 200) {
    var model = TCMODEL.fromJson(jsonDecode(response.body));
    return model;
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class TCMODEL {
  int? status;
  Response? response;

  TCMODEL({this.status, this.response});

  TCMODEL.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  String? id;
  String? name;
  String? surname;
  String? mail;
  String? tel;
  String? img;
  String? age;
  String? password;
  String? iP;
  String? point;
  String? lastPoint;
  String? level;
  String? identifyNumber;
  String? address;
  String? country;
  String? city;
  String? zipcode;
  String? smsCode;
  String? resetPasswd;
  String? resetPasswdDate;
  String? lastLogin;
  String? giftID;
  String? inviterID;
  String? addFriendID;
  String? createdAt;
  String? isActive;
  String? status;
  String? kelimesayisi;
  String? sonSFRlamaTarihi;

  Response(
      {this.id,
      this.name,
      this.surname,
      this.mail,
      this.tel,
      this.img,
      this.age,
      this.password,
      this.iP,
      this.point,
      this.lastPoint,
      this.level,
      this.identifyNumber,
      this.address,
      this.country,
      this.city,
      this.zipcode,
      this.smsCode,
      this.resetPasswd,
      this.resetPasswdDate,
      this.lastLogin,
      this.giftID,
      this.inviterID,
      this.addFriendID,
      this.createdAt,
      this.isActive,
      this.status,
      this.kelimesayisi,
      this.sonSFRlamaTarihi});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    mail = json['mail'];
    tel = json['tel'];
    img = json['img'];
    age = json['age'];
    password = json['password'];
    iP = json['IP'];
    point = json['point'];
    lastPoint = json['lastPoint'];
    level = json['level'];
    identifyNumber = json['identifyNumber'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    zipcode = json['zipcode'];
    smsCode = json['smsCode'];
    resetPasswd = json['resetPasswd'];
    resetPasswdDate = json['resetPasswdDate'];
    lastLogin = json['lastLogin'];
    giftID = json['giftID'];
    inviterID = json['inviterID'];
    addFriendID = json['addFriendID'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    status = json['status'];
    kelimesayisi = json['kelimesayisi'];
    sonSFRlamaTarihi = json['son_sıfırlama_tarihi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['mail'] = this.mail;
    data['tel'] = this.tel;
    data['img'] = this.img;
    data['age'] = this.age;
    data['password'] = this.password;
    data['IP'] = this.iP;
    data['point'] = this.point;
    data['lastPoint'] = this.lastPoint;
    data['level'] = this.level;
    data['identifyNumber'] = this.identifyNumber;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['smsCode'] = this.smsCode;
    data['resetPasswd'] = this.resetPasswd;
    data['resetPasswdDate'] = this.resetPasswdDate;
    data['lastLogin'] = this.lastLogin;
    data['giftID'] = this.giftID;
    data['inviterID'] = this.inviterID;
    data['addFriendID'] = this.addFriendID;
    data['createdAt'] = this.createdAt;
    data['isActive'] = this.isActive;
    data['status'] = this.status;
    data['kelimesayisi'] = this.kelimesayisi;
    data['son_sıfırlama_tarihi'] = this.sonSFRlamaTarihi;
    return data;
  }
}
