class PremiumModel {
  int? isPremium;
  String? message;
  int? status;
  dynamic response;

  PremiumModel({this.isPremium, this.message, this.status, this.response});

  PremiumModel.fromJson(Map<String, dynamic> json) {
    isPremium = json['isPremium'];
    message = json['message'];
    status = json['status'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isPremium'] = this.isPremium;
    data['message'] = this.message;
    data['status'] = this.status;
    data['response'] = this.response;
    return data;
  }
}
