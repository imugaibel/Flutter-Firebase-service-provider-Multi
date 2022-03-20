import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

class AdsModel {
  AdsModel({
    required this.image,
    required this.createdDate,
    required this.uid,
  });

  String image;
  String createdDate;
  String uid;

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
    image: json["image"],
    createdDate: json["createdDate"],
    uid: json["uid"],
  );

}
