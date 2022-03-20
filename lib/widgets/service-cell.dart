import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';

import '../enums/status.dart';
import 'alert.dart';
import 'comment_dialog.dart';

class ServiceCell extends StatefulWidget {
  final ServiceModel service;

  const ServiceCell(
      {Key? key,
      required this.service,})
      : super(key: key);

  @override
  _ServiceCellState createState() => _ServiceCellState();
}

class _ServiceCellState extends State<ServiceCell> {
  Language lang = Language.ENGLISH;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      if (value != null) {
        setState(() {
          lang = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _scaffoldKey,
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.of(context)
              .pushNamed("/ServiceDetails", arguments: widget.service.uid),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.network(
                          widget.service.images.first,
                          width: MediaQuery.of(context).size.width * 80 / 375,
                          height: MediaQuery.of(context).size.height * 80 / 812,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!
                                  .translate("User name: "),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                            FutureBuilder<UserModel>(
                                future: FirebaseManager.shared
                                    .getUserByUid(uid: widget.service.uidOwner),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.name,
                                      style: const TextStyle(
                                          color: Colors.blueGrey, fontSize: 16),
                                    );
                                  } else {
                                    return const Text("");
                                  }
                                }),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!
                                  .translate("Service name: "),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                            Text(
                              lang == Language.ARABIC
                                  ? widget.service.titleAR.length < 15
                                      ? widget.service.titleAR
                                      : widget.service.titleAR
                                              .substring(0, 15) +
                                          "..."
                                  : widget.service.titleEN.length < 15
                                      ? widget.service.titleEN
                                      : widget.service.titleEN
                                              .substring(0, 15) +
                                          "...",
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 40 / 812,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.service.status == Status.ACTIVE,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              FirebaseManager.shared.changeServiceStatus(
                                  _scaffoldKey.currentContext,
                                  service: widget.service,
                                  status: Status.Disable);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height *
                                  (50 / 812),
                              decoration: const BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalization.of(context)!
                                    .translate("disabled"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.service.status == Status.PENDING,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              FirebaseManager.shared.changeServiceStatus(
                                  _scaffoldKey.currentContext,
                                  service: widget.service,
                                  status: Status.ACTIVE);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height *
                                  (50 / 812),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalization.of(context)!
                                    .translate("Accept"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.service.status == Status.Disable,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              FirebaseManager.shared.changeServiceStatus(
                                  _scaffoldKey.currentContext,
                                  service: widget.service,
                                  status: Status.ACTIVE);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height *
                                  (50 / 812),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalization.of(context)!
                                    .translate("activation"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.service.status == Status.PENDING,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              commentDialog(context,
                                  titleBtn: AppLocalization.of(context)!
                                      .translate("Reject"),
                                  action: (commentEN, commentAR) async {
                                if (commentEN == "" || commentAR == "") {
                                  _scaffoldKey.showTosta(
                                      message: AppLocalization.of(context)!
                                          .translate(
                                              "Please fill in all fields"),
                                      isError: true);
                                  return;
                                }
                                Navigator.of(context).pop();
                                FirebaseManager.shared.changeServiceStatus(
                                    _scaffoldKey.currentContext,
                                    service: widget.service,
                                    status: Status.Rejected,
                                    messageEN: commentEN,
                                    messageAR: commentAR);
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height *
                                  (50 / 812),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalization.of(context)!
                                    .translate("Reject"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.service.status == Status.Deleted,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showAlertDialog(context,
                                  title: AppLocalization.of(context)!
                                      .translate("Delete Service"),
                                  message: AppLocalization.of(context)!
                                      .translate(
                                          "Are you sure to delete the service?"),
                                  titleBtnOne: "Delete",
                                  titleBtnTwo: "Close", actionBtnOne: () {
                                Navigator.of(context).pop();
                                FirebaseManager.shared.deleteService(
                                    _scaffoldKey.currentContext,
                                    idService: widget.service.uid);
                                Navigator.of(context).pop();
                              }, actionBtnTwo: () {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height *
                                  (50 / 812),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                AppLocalization.of(context)!
                                    .translate("Delete"),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
