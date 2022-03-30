import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/notifications.dart';

import '../../widgets/alert.dart';

class Service extends StatefulWidget {
  const Service({Key? key}) : super(key: key);

  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
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
    return FutureBuilder<UserModel?>(
        key: _scaffoldKey,
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalization.of(context)!.translate("Services")),
                centerTitle: true,
                actions: [
                  const NotificationsWidget(),
                  Visibility(visible: user!.userType == UserType.TECHNICIAN,
                      child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white,),
                          tooltip: AppLocalization.of(context)!.translate(
                              "Add Service"),
                          onPressed: () =>
                              Navigator.of(context).pushNamed("/ServiceForm"))),
                ],
              ),
              body: user.userType == UserType.TECHNICIAN
                  ? _widgetTech(context)
                  : _widgetUser(context),
            );
          }

          return const SizedBox();
        }
    );
  }

  Widget _widgetUser(context) {
    return StreamBuilder<List<ServiceModel>>(
        stream: FirebaseManager.shared.getServices(status: Status.ACTIVE),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceModel>? services = snapshot.data;
            if (services!.isEmpty) {
              return Center(child: Text(AppLocalization.of(context)!.translate(
                  "No services have been added"), style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }
            return GridView.count(
              padding: const EdgeInsets.all(10),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(services.length, (index) {
                return InkWell(
                  onTap: () => Navigator.of(context).pushNamed(
                      "/ServiceDetails", arguments: services[index].uid),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12))
                          ),
                          child: Image.network(
                            services[index].images.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(lang == Language.ARABIC
                          ? services[index].titleAR
                          : services[index].titleEN,
                        style: TextStyle(color: Theme
                            .of(context)
                            .primaryColor, fontSize: 18, fontWeight: FontWeight
                            .w500,),)
                    ],
                  ),
                );
              }),
            );
          } else {
            return Center(child: loader(context));
          }
        }
    );
  }

  Widget _widgetTech(context) {
    return StreamBuilder<List<ServiceModel>>(
        stream: FirebaseManager.shared.getMyServices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceModel>? services = snapshot.data;
            if (services!.isEmpty) {
              return Center(child: Text(AppLocalization.of(context)!.translate(
                  "You have not added any services"),
                style: TextStyle(color: Theme
                    .of(context)
                    .primaryColor, fontSize: 18),));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: services.length,
              itemBuilder: (context, index) {
                String statusTitle = "";
                Widget statusIcon = const Icon(
                  Icons.check, size: 22, color: Colors.green,);

                switch (services[index].status) {
                  case Status.ACTIVE:
                    statusTitle = "Activity";
                    statusIcon =
                    const Icon(Icons.check, size: 22, color: Colors.green,);
                    break;
                  case Status.PENDING:
                    statusTitle = "In Review";
                    statusIcon = const Icon(
                      Icons.access_time, size: 22, color: Colors.yellow,);
                    break;
                  case Status.Rejected:
                    statusTitle = "Rejected";
                    statusIcon =
                    const Icon(Icons.report, size: 18, color: Colors.red,);
                    break;
                  case Status.Deleted:
                    statusTitle = "Delete";
                    statusIcon =
                    const Icon(Icons.report, size: 18, color: Colors.red,);
                    break;
                  case Status.Finished:
                  // TODO: Handle this case.
                    break;
                  case Status.Disable:
                    statusTitle = "disable";
                    statusIcon =
                    const Icon(Icons.report, size: 18, color: Colors.orangeAccent,);
                    break;
                  case Status.canceled:
                  // TODO: Handle this case.
                    break;
                }

                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed(
                                  "/ServiceDetails", arguments: services[index]
                                  .uid),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme
                                  .of(context)
                                  .primaryColor),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(15)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * (100 / 375),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .width * (100 / 375),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .primaryColor),
                                  ),
                                  child: Image.network(
                                    services[index].images.first,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                Row(
                                  children: [
                                    Text(AppLocalization.of(context)!.translate(
                                        "Title: "), style: TextStyle(
                                        fontSize: 18, color: Theme
                                        .of(context)
                                        .primaryColor),),
                                    const SizedBox(width: 10),
                                    Text(lang == Language.ARABIC
                                        ? services[index].titleAR
                                        : services[index].titleEN,
                                        style: TextStyle(
                                            fontSize: 16, color: Theme
                                            .of(context)
                                            .colorScheme.secondary)),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text(AppLocalization.of(context)!.translate(
                                        "Date created: "), style: TextStyle(
                                        fontSize: 18, color: Theme
                                        .of(context)
                                        .primaryColor),),
                                    const SizedBox(width: 10),
                                    Text(services[index].createdDate
                                        .changeDateFormat(), style: TextStyle(
                                        fontSize: 16, color: Theme
                                        .of(context)
                                        .colorScheme.secondary),),
                                  ],
                                ),
                                Visibility(
                                  visible: services[index].status ==
                                      Status.Rejected,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Text(AppLocalization.of(context)!
                                              .translate("Reason of refuse: "),
                                            style: TextStyle(
                                                fontSize: 18, color: Theme
                                                .of(context)
                                                .primaryColor),),
                                          const SizedBox(width: 10),
                                          Text(lang == Language.ARABIC
                                              ? services[index].messageAR
                                              : services[index].messageEN,
                                              style: TextStyle(
                                                  fontSize: 16, color: Theme
                                                  .of(context)
                                                  .colorScheme.secondary)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 35),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .primaryColor),
                                  ),
                                  child: SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        statusIcon,
                                        const SizedBox(width: 10),
                                        Text(AppLocalization.of(context)!
                                            .translate(statusTitle),
                                          style: TextStyle(
                                              fontSize: 16, color: Theme
                                              .of(context)
                                              .colorScheme.secondary),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(icon: const Icon(
                          Icons.delete_forever, size: 36, color: Colors.red,),
                            tooltip: AppLocalization.of(context)!.translate(
                                "delete service"),
                            onPressed: () {
                              showAlertDialog(context,
                                  title: AppLocalization.of(context)!.translate(
                                      "Delete"),
                                  message: AppLocalization.of(context)!
                                      .translate("Are you sure delete service"),
                                  titleBtnOne: "Delete",
                                  titleBtnTwo: "Cancel",
                                  actionBtnOne: () {
                                    Navigator.of(context).pop();
                                    FirebaseManager.shared.changeServiceStatus(
                                        _scaffoldKey.currentContext,
                                        service: services[index],
                                        status: Status.Deleted);
                                  },
                                  actionBtnTwo: () {
                                    Navigator.of(context).pop();
                                  });
                            })
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: loader(context),
            );
          }
        }
    );
  }
}