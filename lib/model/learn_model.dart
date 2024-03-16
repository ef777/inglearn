class LearnModel {
  int? status;
  List<Response>? response;

  LearnModel({this.status, this.response});

  LearnModel.fromJson(Map<String, dynamic> json) {
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
  String? engTitle;
  String? engDesc;
  String? trTitle;
  String? trDesc;
  String? status;
  String? createdAt;

  Response(
      {this.id,
      this.engTitle,
      this.engDesc,
      this.trTitle,
      this.trDesc,
      this.status,
      this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    engTitle = json['eng_title'];
    engDesc = json['eng_desc'];
    trTitle = json['tr_title'];
    trDesc = json['tr_desc'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['eng_title'] = engTitle;
    data['eng_desc'] = engDesc;
    data['tr_title'] = trTitle;
    data['tr_desc'] = trDesc;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
