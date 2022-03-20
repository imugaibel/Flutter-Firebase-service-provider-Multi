import 'dart:convert';

import 'package:meta/meta.dart';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.uidSender,
    required this.uidService,
    required this.uidReceiver,
    required this.message,
    required this.image,
    required this.createdDate,
    required this.uid,
    required this.uidUser,
    required this.uidOrder,
  });

  String uidSender;
  String uidService;
  String uidReceiver;
  String message;
  String image;
  String createdDate;
  String uid;
  String uidOrder;
  String uidUser;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        uidSender: json["uid-sender"],
        uidService: json["uid-service"],
        uidReceiver: json["uid-receiver"],
        message: json["message"],
        image: json["image"],
        createdDate: json["createdDate"],
        uid: json["uid"],
        uidUser: json["uid-user"],
        uidOrder: json["uid-order"],
      );

  Map<String, dynamic> toJson() => {
        "uid-sender": uidSender,
        "uid-service": uidService,
        "uid-receiver": uidReceiver,
        "message": message,
        "image": image,
        "createdDate": createdDate,
        "uid": uid,
        "uid-user": uidUser,
        "uid-order": uidOrder,
      };
}
