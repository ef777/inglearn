class SpinModel {
  int? status;
  Response? response;

  SpinModel({this.status, this.response});

  SpinModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? id;
  String? title;
  String? description;
  String? status;
  String? createdAt;

  Response(
      {this.id, this.title, this.description, this.status, this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    return data;
  }
}
