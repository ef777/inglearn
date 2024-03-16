// ignore_for_file: file_names

class PointsModel {
  int? status;
  Response? response;

  PointsModel({this.status, this.response});

  PointsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'] != null
        // ignore: unnecessary_new
        ? new Response.fromJson(json['response'])
        : null;
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
  String? name;
  String? surname;
  String? mail;
  String? tel;
  String? age;
  String? password;
  String? iP;
  String? point;
  String? lastPoint;
  String? level;
  String? smsCode;
  String? resetPasswd;
  String? lastLogin;
  String? createdAt;
  String? isActive;
  String? status;

  Response(
      {this.id,
      this.name,
      this.surname,
      this.mail,
      this.tel,
      this.age,
      this.password,
      this.iP,
      this.point,
      this.lastPoint,
      this.level,
      this.smsCode,
      this.resetPasswd,
      this.lastLogin,
      this.createdAt,
      this.isActive,
      this.status});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    mail = json['mail'];
    tel = json['tel'];
    age = json['age'];
    password = json['password'];
    iP = json['IP'];
    point = json['point'];
    lastPoint = json['lastPoint'];
    level = json['level'];
    smsCode = json['smsCode'];
    resetPasswd = json['resetPasswd'];
    lastLogin = json['lastLogin'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['mail'] = mail;
    data['tel'] = tel;
    data['age'] = age;
    data['password'] = password;
    data['IP'] = iP;
    data['point'] = point;
    data['lastPoint'] = lastPoint;
    data['level'] = level;
    data['smsCode'] = smsCode;
    data['resetPasswd'] = resetPasswd;
    data['lastLogin'] = lastLogin;
    data['createdAt'] = createdAt;
    data['isActive'] = isActive;
    data['status'] = status;
    return data;
  }
}
