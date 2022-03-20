import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  NotificationModel({
    required this.userId,
    required this.titleEn,
    required this.titleAr,
    required this.detailsEn,
    required this.detailsAr,
    required this.createdDate,
    required this.uid,
    required this.isRead,
  });

  String userId;
  String titleEn;
  String titleAr;
  String detailsEn;
  String detailsAr;
  String createdDate;
  String uid;
  bool isRead;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    userId: json["user-id"],
    titleEn: json["title-en"],
    titleAr: json["title-ar"],
    detailsEn: json["details-en"],
    detailsAr: json["details-ar"],
    createdDate: json["createdDate"],
    uid: json["uid"],
    isRead: json["is-read"],
  );

}
