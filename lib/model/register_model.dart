class RegisterModel {
  int? status;
  bool? isRegister;
  Response? response;

  RegisterModel({this.status, this.isRegister, this.response});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isRegister = json['isRegister'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['isRegister'] = isRegister;
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
  dynamic point;
  dynamic smsCode;
  dynamic resetPasswd;
  dynamic lastLogin;
  String? createdAt;
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
      this.smsCode,
      this.resetPasswd,
      this.lastLogin,
      this.createdAt,
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
    smsCode = json['smsCode'];
    resetPasswd = json['resetPasswd'];
    lastLogin = json['lastLogin'];
    createdAt = json['createdAt'];
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
    data['smsCode'] = smsCode;
    data['resetPasswd'] = resetPasswd;
    data['lastLogin'] = lastLogin;
    data['createdAt'] = createdAt;
    data['status'] = status;
    return data;
  }
}
