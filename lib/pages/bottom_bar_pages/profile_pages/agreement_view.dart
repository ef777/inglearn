import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kartal/kartal.dart';

import '../../../const/const.dart';
import 'package:html/parser.dart' show parse;

import 'details_view.dart';

class AgreementView extends StatelessWidget {
  const AgreementView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text('Sözleşmeler'),
        ),
        body: FutureBuilder<AggremantModel>(
          future: getAggerament(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.response?.length,
                itemBuilder: (context, index) {
                  final document = parse(
                      snapshot.data?.response?[0].desc.toString() ??
                          "Veri Yok");
                  final text = parse(document.body!.text).documentElement!.text;
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(snapshot.data?.response?[index].title ??
                                    "Veri Yok"),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      context.navigateToPage(DetailsView(
                                          text: text,
                                          title: snapshot.data?.response?[index]
                                                  .title ??
                                              "Veri Yok"));
                                    },
                                    icon: Icon(Icons.arrow_forward_ios))
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

Future<AggremantModel> getAggerament() async {
  var response = await http.post(
    Uri.parse("https://vocopus.com/api/v1/getContracts"),
    body: {
      "apiToken": apiToken,
    },
  );

  if (response.statusCode == 200) {
    return AggremantModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Kayıt Başarısız');
  }
}

class AggremantModel {
  int? status;
  List<Response>? response;

  AggremantModel({this.status, this.response});

  AggremantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? title;
  String? desc;
  String? status;
  String? createdAt;

  Response({this.id, this.title, this.desc, this.status, this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
