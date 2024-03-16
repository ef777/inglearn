// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:english_learn/const/const.dart';
import 'package:english_learn/model/login_model.dart';
import 'package:http/http.dart' as http;

Future<int> forgotPasswordService(String? tel) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/resetPasswordMail"),
    body: {
      "apiToken": apiToken,
      "email": tel ?? "",
    },
  );
  print(response.body);
  // JSON string'i parse et
  Map<String, dynamic> parsedJson = jsonDecode(response.body);

  // Status değerini al
  int status = parsedJson['status'];
  return status;
  //return LoginModel.fromJson(jsonDecode(response.body));
}

Future<int> vertificationService(String? tel, String code) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/resetPasswordCode"),
    body: {
      "apiToken": apiToken,
      "email": tel ?? "",
      "code": code,
    },
  );
  print(response.body);
  // JSON string'i parse et
  Map<String, dynamic> parsedJson = jsonDecode(response.body);

  // Status değerini al
  int status = parsedJson['status'];
  return status;
  //return LoginModel.fromJson(jsonDecode(response.body));
}

Future<int> newPasswordService(
    String? mail, String pass1, String pass2) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/resetPassword"),
    body: {
      "apiToken": apiToken,
      "email": mail ,
      "password": pass1,
      "passwordAgain": pass2,
    },
  );
  print(response.body);
  // JSON string'i parse et
  Map<String, dynamic> parsedJson = jsonDecode(response.body);

  // Status değerini al
  int status = parsedJson['status'];
  return status;
  //return LoginModel.fromJson(jsonDecode(response.body));
}
