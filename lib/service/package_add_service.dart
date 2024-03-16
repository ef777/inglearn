// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:english_learn/const/const.dart';
import 'package:http/http.dart' as http;

Future<void> addPackageService(String? package_id) async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/usersStoreBuy"),
    body: {
      "apiToken": apiToken,
      "user_id": configID,
      "packet_id": package_id ?? ""
    },
  );
  print(response.body);
}
