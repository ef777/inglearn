class Ulke {
  String? id;
  String? rewrite;
  String? baslik;
  String? alankodu;
  List<Cities>? cities;

  Ulke({this.id, this.rewrite, this.baslik, this.alankodu, this.cities});
  
 factory Ulke.fromJson(Map<String, dynamic> json) {
    return Ulke(
      id: json['id'],
      rewrite: json['rewrite'],
      baslik: json['baslik'],
      alankodu: json['alankodu'],
      cities: json['cities'] != null
          ? List<Cities>.from(json['cities'].map((x) => Cities.fromJson(x)))
          : null,
    );


}}

class Cities {
  String? id;
  String? baslik;
  String? ulkeId;

  Cities({this.id, this.baslik, this.ulkeId});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    baslik = json['baslik'];
    ulkeId = json['ulke_id'];
  }

 
}
