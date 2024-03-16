class LeaderStatusModel {
  int? status;
  List<Users>? users;

  LeaderStatusModel({this.status, this.users});

  LeaderStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String? id;
  String? name;
  String? surname;
  String? mail;
  String? tel;
  String? img;
  String? age;
  String? password;
  String? iP;
  String? point;
  String? lastPoint;
  String? level;
  String? identifyNumber;
  String? address;
  String? country;
  String? city;
  String? zipcode;
  Null? smsCode;
  String? resetPasswd;
  String? resetPasswdDate;
  String? lastLogin;
  String? giftID;
  String? inviterID;
  String? addFriendID;
  String? createdAt;
  String? isActive;
  String? status;
  String? kelimesayisi;
  String? sonSFRlamaTarihi;

  Users(
      {this.id,
      this.name,
      this.surname,
      this.mail,
      this.tel,
      this.img,
      this.age,
      this.password,
      this.iP,
      this.point,
      this.lastPoint,
      this.level,
      this.identifyNumber,
      this.address,
      this.country,
      this.city,
      this.zipcode,
      this.smsCode,
      this.resetPasswd,
      this.resetPasswdDate,
      this.lastLogin,
      this.giftID,
      this.inviterID,
      this.addFriendID,
      this.createdAt,
      this.isActive,
      this.status,
      this.kelimesayisi,
      this.sonSFRlamaTarihi});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    mail = json['mail'];
    tel = json['tel'];
    img = json['img'];
    age = json['age'];
    password = json['password'];
    iP = json['IP'];
    point = json['point'];
    lastPoint = json['lastPoint'];
    level = json['level'];
    identifyNumber = json['identifyNumber'];
    address = json['address'];
    country = json['country'];
    city = json['city'];
    zipcode = json['zipcode'];
    smsCode = json['smsCode'];
    resetPasswd = json['resetPasswd'];
    resetPasswdDate = json['resetPasswdDate'];
    lastLogin = json['lastLogin'];
    giftID = json['giftID'];
    inviterID = json['inviterID'];
    addFriendID = json['addFriendID'];
    createdAt = json['createdAt'];
    isActive = json['isActive'];
    status = json['status'];
    kelimesayisi = json['kelimesayisi'];
    sonSFRlamaTarihi = json['son_sıfırlama_tarihi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['mail'] = this.mail;
    data['tel'] = this.tel;
    data['img'] = this.img;
    data['age'] = this.age;
    data['password'] = this.password;
    data['IP'] = this.iP;
    data['point'] = this.point;
    data['lastPoint'] = this.lastPoint;
    data['level'] = this.level;
    data['identifyNumber'] = this.identifyNumber;
    data['address'] = this.address;
    data['country'] = this.country;
    data['city'] = this.city;
    data['zipcode'] = this.zipcode;
    data['smsCode'] = this.smsCode;
    data['resetPasswd'] = this.resetPasswd;
    data['resetPasswdDate'] = this.resetPasswdDate;
    data['lastLogin'] = this.lastLogin;
    data['giftID'] = this.giftID;
    data['inviterID'] = this.inviterID;
    data['addFriendID'] = this.addFriendID;
    data['createdAt'] = this.createdAt;
    data['isActive'] = this.isActive;
    data['status'] = this.status;
    data['kelimesayisi'] = this.kelimesayisi;
    data['son_sıfırlama_tarihi'] = this.sonSFRlamaTarihi;
    return data;
  }
}
