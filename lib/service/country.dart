// ignore_for_file: file_names, avoid_print, depend_on_referenced_packages

import 'dart:convert';

import 'package:english_learn/model/ulkelermodel.dart';
import 'package:http/http.dart' as http;

import '../const/const.dart';
import '../model/register_model.dart';

Future<List<Ulke>> Ulkelergetir() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getCountries"),
    body: {
      "apiToken": apiToken,
      
    },
  );
 // print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> mapim = jsonDecode(response.body);

    List<Ulke> ulkelerList = await mapim.map((json) => Ulke.fromJson(json)).toList();
    print(ulkelerList.length);
    return ulkelerList;

  } else {
    throw Exception('Failed to load ulkeler');
  }
}
