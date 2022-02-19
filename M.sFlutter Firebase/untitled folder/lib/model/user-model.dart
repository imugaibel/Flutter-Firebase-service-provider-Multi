import 'dart:convert';

import 'package:omni/enums/status.dart';
import 'package:omni/enums/user-type.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.image,
    this.name,
    this.phone,
    this.email,
    this.city,
    this.uid,
    this.accountStatus,
    this.userType,
    this.balance,
    this.lat,
    this.lng,
    this.dateCreated,
  });

  String id;
  String image;
  String name;
  String phone;
  String email;
  String city;
  String uid;
  Status accountStatus;
  UserType userType;
  double balance;
  double lat;
  double lng;
  String dateCreated;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    city: json["city"],
    uid: json["uid"],
    balance: (json["balance"] != null ? json["balance"] : 0) * 1.0,
    lat: (json["lat"] != null ? json["lat"] : -1) * 1.0,
    lng: (json["lng"] != null ? json["lng"] : -1) * 1.0,
    accountStatus: Status.values[json["status-account"]],
    userType: UserType.values[json["type-user"]],
    dateCreated: json["date-created"] == null ? DateTime.now().toString() : json["date-created"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "phone": phone,
    "email": email,
    "city": city,
    "uid": uid,
    "balance": balance,
    "lat": lat,
    "lng": lng,
    "status-account": accountStatus.index,
    "type-user": userType.index,
    "date-created": dateCreated,
  };
}
