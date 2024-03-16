class TestModel {
  int? status;
  List<Response>? response;

  TestModel({this.status, this.response});

  TestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? word;
  String? answer1;
  String? answer2;
  String? answer3;
  String? answer4;
  String? answer5;
  String? answer6;
  String? correctAnsw;
  String? level;
  String? status;
  String? createdAt;

  Response(
      {this.id,
      this.word,
      this.answer1,
      this.answer2,
      this.answer3,
      this.answer4,
      this.answer5,
      this.answer6,
      this.correctAnsw,
      this.level,
      this.status,
      this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    word = json['word'];
    answer1 = json['answer_1'];
    answer2 = json['answer_2'];
    answer3 = json['answer_3'];
    answer4 = json['answer_4'];
    answer5 = json['answer_5'];
    answer6 = json['answer_6'];
    correctAnsw = json['correct_answ'];
    level = json['level'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['word'] = word;
    data['answer_1'] = answer1;
    data['answer_2'] = answer2;
    data['answer_3'] = answer3;
    data['answer_4'] = answer4;
    data['answer_5'] = answer5;
    data['answer_6'] = answer6;
    data['correct_answ'] = correctAnsw;
    data['level'] = level;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
