import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/comment_dialog.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/widgets/notifications.dart';

import '../chat.dart';

class RequestServices extends StatefulWidget {
  const RequestServices({Key? key}) : super(key: key);

  @override
  _RequestServicesState createState() => _RequestServicesState();
}

class _RequestServicesState extends State<RequestServices> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:
              Text(AppLocalization.of(context)!.translate("Request Service")),
          centerTitle: true,
          actions: const [
            NotificationsWidget(),
          ],
        ),
        body: FutureBuilder<UserModel?>(
            future: UserProfile.shared.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel user = snapshot.data!;

                return StreamBuilder<List<OrderModel>>(
                    stream: FirebaseManager.shared.getMyOrdersTech(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<OrderModel> services = [];

                        for (var service in snapshot.data!) {
                          if (service.ownerId == user.uid) {
                            services.add(service);
                          }
                        }

                        return services.isEmpty
                            ? Center(
                                child: Text(
                                  AppLocalization.of(context)!
                                      .translate("You have no new requests"),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: services.length,
                                itemBuilder: (context, index) {
                                  return _item(context, item: services[index]);
                                },
                              );
                      } else {
                        return Center(child: loader(context));
                      }
                    });
              }
              return const SizedBox();
            }));
  }

  Widget _item(context, {required OrderModel item}) {
    String statusTitle = "";
    Widget statusIcon = const Icon(
      Icons.check,
      size: 22,
      color: Colors.green,
    );

    switch (item.status) {
      case Status.ACTIVE:
        statusTitle = AppLocalization.of(context)!.translate("Activity");
        statusIcon = const Icon(
          Icons.timer,
          size: 22,
          color: Colors.blue,
        );
        break;
      case Status.PENDING:
        statusTitle = AppLocalization.of(context)!.translate("In Review");
        statusIcon = const Icon(
          Icons.update,
          size: 22,
          color: Colors.yellow,
        );
        break;
      case Status.Rejected:
        statusTitle = AppLocalization.of(context)!.translate("Rejected");
        statusIcon = const Icon(
          Icons.report,
          size: 22,
          color: Colors.red,
        );
        break;
      case Status.Finished:
        statusTitle = AppLocalization.of(context)!.translate("Finished");
        statusIcon = const Icon(
          Icons.check,
          size: 22,
          color: Colors.green,
        );
        break;
      case Status.Deleted:
        // TODO: Handle this case.
        break;
      case Status.Disable:
        // TODO: Handle this case.
        break;
      case Status.canceled:
        statusTitle = AppLocalization.of(context)!.translate("cancele");
        statusIcon = const Icon(
          Icons.report,
          size: 22,
          color: Colors.orange,
        );
        break;
    }

    return FutureBuilder<UserModel>(
        future: FirebaseManager.shared.getUserByUid(uid: item.userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed("/OrderDetails", arguments: item),
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalization.of(context)!
                                      .translate("User name: "),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                                visible: item.status == Status.ACTIVE,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Chat(
                                          order: item,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.chat,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!.translate("Phone: "),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 10),
                            Text(user.phone,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.secondary)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!
                                  .translate("Service: "),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 10),
                            StreamBuilder<ServiceModel>(
                                stream: FirebaseManager.shared
                                    .getServiceById(id: item.serviceId),
                                builder: (context, snapshot) {
                                  return Text(
                                      snapshot.hasData
                                          ? lang == Language.ARABIC
                                              ? snapshot.data!.titleAR
                                              : snapshot.data!.titleEN
                                          : "",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).colorScheme.secondary));
                                }),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context)!.translate("Date: "),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              item.createdDate.changeDateFormat(
                                  format: "yyyy-MM-dd - h:mm a"),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: item.status == Status.Rejected,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    AppLocalization.of(context)!
                                        .translate("Reason of refuse: "),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                      lang == Language.ARABIC
                                          ? item.messageAR: item.messageEN,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.secondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: item.status == Status.canceled,
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(
                                    AppLocalization.of(context)!
                                        .translate("Reason of cancele: "),
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                      lang == Language.ARABIC
                                          ? item.messageAR: item.messageEN,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context).colorScheme.secondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: item.status == Status.PENDING,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      FirebaseManager.shared.changeOrderStatus(
                                          _scaffoldKey.currentContext,
                                          uid: item.uid,
                                          status: Status.ACTIVE);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              (50 / 812),
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
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
                                  InkWell(
                                    onTap: () => _btnReject(uid: item.uid),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              (50 / 812),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
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
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: item.status == Status.ACTIVE,
                              child: Row(
                                children: [

                                  InkWell(
                                    onTap: () {
                                      FirebaseManager.shared.changeOrderStatus(
                                          _scaffoldKey.currentContext,
                                          uid: item.uid,
                                          status: Status.Finished);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      height: MediaQuery.of(context).size.height *
                                          (50 / 812),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.green),
                                        borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Center(
                                          child: Text(
                                            AppLocalization.of(context)!
                                                .translate("End the service"),
                                            style: const TextStyle(
                                                color: Colors.green, fontSize: 18),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Theme.of(context).primaryColor),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                statusIcon,
                                const SizedBox(width: 10),
                                Text(
                                  statusTitle,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.secondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])),
                ),
                const SizedBox(height: 10),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
  }

  _btnReject({required String uid}) {
    commentDialog(context,
        titleBtn: AppLocalization.of(context)!.translate("Reject"),
        action: (commentEN, commentAR) async {
      if (commentEN == "" || commentAR == "") {
        _scaffoldKey.showTosta(
            message: AppLocalization.of(context)!
                .translate("Please fill in all fields"),
            isError: true);
        return;
      } else {
        Navigator.of(context).pop();

        FirebaseManager.shared.changeOrderStatus(
          _scaffoldKey.currentContext,
          uid: uid,
          status: Status.Rejected,
          messageEN: commentEN,
          messageAR: commentAR,
        );
      }
    });
  }
}
