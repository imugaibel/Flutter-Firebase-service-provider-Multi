// To parse this JSON data, do

//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:maintenance/enums/status.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    required this.userId,
    required this.serviceId,
    required this.ownerId,
    required this.details,
    required this.createdDate,
    required this.status,
    required this.messageEN,
    required this.messageAR,
    required this.uid,
//    required this.urlImage,
//     required this.lat,
//     required this.lng,
  });

  String userId;
  String serviceId;
  String ownerId;

//  double lat;
//   double lng;
//   String urlImage;
  String details;
  String createdDate;
  Status status;
  String messageEN;
  String messageAR;
  String uid;

  factory OrderModel.fromJson(Map<String, dynamic>? json) => OrderModel(
        userId: json!["user-id"],
        serviceId: json["service-id"],
        ownerId: json["owner-id"],
        details: json["details"],
        createdDate: json["createdDate"],
        status: Status.values[json["status"]],
        messageEN: json["message-en"],
        messageAR: json["message-ar"],
//     urlImage: json["url-image"],
//     lat: json["lat"].toDouble(),
//      lng: json["lng"].toDouble(),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "user-id": userId,
        "service-id": serviceId,
        "owner-id": ownerId,
//        "lat": lat,
//         "lng": lng,
//         "url-image": urlImage,
        "details": details,
        "createdDate": createdDate,
        "status": status.index,
        "message-en": messageEN,
        "message-ar": messageAR,
        "uid": uid,
      };
}
