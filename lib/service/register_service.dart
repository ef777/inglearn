// ignore_for_file: file_names, avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../const/const.dart';
import '../model/register_model.dart';

Future<RegisterModel> registerService(
    {required String? name,
    required String? username,
    required String? surname,
    required String? email,
    required String? passwd,
    required String? tel,
    required String? level,
    required String? age,
    required String? country,
    required String? city,
    required String? identifyNumber,
    required String? address,
    required String? zipcode,
    required String? passwdAgain}) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/register"),
    body: {
      "apiToken": apiToken,
      "username": username,
      "name": name,
      "surname": surname,
      "tel": (tel),
      "age": (age),
      "email": email,
      "passwd": passwd,
      "passwdAgain": passwdAgain,
      "level": level,
      "country": country,
      "city": city,
      "identifyNumber": identifyNumber,
      "address": address,
      "zipcode": zipcode,
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return RegisterModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}
