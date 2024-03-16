class QuestionModel {
  int? status;
  List<Response>? response;

  QuestionModel({this.status, this.response});

  QuestionModel.fromJson(Map<String, dynamic> json) {
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
  String? question;
  String? answer1;
  String? answer2;
  String? answer3;
  String? answer4;
  String? correctAnsw;
  String? status;
  String? createdAt;

  Response(
      {this.id,
      this.question,
      this.answer1,
      this.answer2,
      this.answer3,
      this.answer4,
      this.correctAnsw,
      this.status,
      this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer1 = json['answer_1'];
    answer2 = json['answer_2'];
    answer3 = json['answer_3'];
    answer4 = json['answer_4'];
    correctAnsw = json['correct_answ'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['answer_1'] = answer1;
    data['answer_2'] = answer2;
    data['answer_3'] = answer3;
    data['answer_4'] = answer4;
    data['correct_answ'] = correctAnsw;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
