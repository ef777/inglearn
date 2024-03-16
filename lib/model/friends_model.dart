class FriednsModel {
  int? status;
  List<Response>? response;

  FriednsModel({this.status, this.response});

  FriednsModel.fromJson(Map<String, dynamic> json) {
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
  String? friend1;
  String? friend2;

  Response({this.id, this.friend1, this.friend2});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    friend1 = json['friend1'];
    friend2 = json['friend2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['friend1'] = friend1;
    data['friend2'] = friend2;
    return data;
  }
}
