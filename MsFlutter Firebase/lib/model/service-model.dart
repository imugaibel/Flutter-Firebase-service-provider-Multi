import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:maintenance/enums/status.dart';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

class ServiceModel {
  ServiceModel({
    this.images,
    this.titleEN,
    this.detailsEN,
    this.titleAR,
    this.detailsAR,
    this.createdDate,
    this.uidOwner,
    this.status,
    this.messageEN,
    this.messageAR,
    this.uid,
  });

  List <String> images;
  String titleEN;
  String detailsEN;
  String titleAR;
  String detailsAR;
  String createdDate;
  String uidOwner;
  Status status;
  String messageEN;
  String messageAR;
  String uid;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    images: json["images"].toString().split(", "),
    titleEN: json["title-en"],
    detailsEN: json["details-en"],
    titleAR: json["title-ar"],
    detailsAR: json["details-ar"],
    createdDate: json["createdDate"],
    uidOwner: json["uid-owner"],
    status: Status.values[json["status"]],
    messageEN: json["message-en"],
    messageAR: json["message-ar"],
    uid: json["uid"],
  );

}