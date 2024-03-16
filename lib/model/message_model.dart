class MessageModel {
  int? status;
  List<Response>? response;

  MessageModel({this.status, this.response});

  MessageModel.fromJson(Map<String, dynamic> json) {
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
  String? senderID;
  String? receiverID;
  String? message;
  String? createdAt;

  Response(
      {this.id, this.senderID, this.receiverID, this.message, this.createdAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderID = json['senderID'];
    receiverID = json['receiverID'];
    message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['senderID'] = senderID;
    data['receiverID'] = receiverID;
    data['message'] = message;
    data['createdAt'] = createdAt;
    return data;
  }
}
