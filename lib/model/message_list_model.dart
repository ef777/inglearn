class MessageModelList {
  int? status;
  List<Response>? response;

  MessageModelList({this.status, this.response});

  MessageModelList.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderID'] = this.senderID;
    data['receiverID'] = this.receiverID;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
