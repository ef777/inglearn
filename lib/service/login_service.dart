// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:english_learn/const/const.dart';
import 'package:english_learn/model/login_model.dart';
import 'package:http/http.dart' as http;

Future<LoginModel> loginService(String? tel, String? passwd) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/login"),
    body: {"apiToken": apiToken, "username": tel ?? "", "passwd": passwd ?? ""},
  );
  print(response.body);

  return LoginModel.fromJson(jsonDecode(response.body));
}

Future<void> userRemove() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/removeUser"),
    body: {"apiToken": apiToken, "userID": configID},
  );
  print(response.body);
}



