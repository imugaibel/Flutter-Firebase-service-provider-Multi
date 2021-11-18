import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/notifications.dart';

class Service extends StatefulWidget {
  @override
  _ServiceState createState() => _ServiceState();
}

class _ServiceState extends State<Service> {

  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: UserProfile.shared.getUser(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserModel user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalization.of(context).translate("Services")),
              centerTitle: true,
              actions: [
                NotificationsWidget(),
                Visibility(visible: user.userType == UserType.TECHNICIAN, child: IconButton(icon: Icon(Icons.add, color: Colors.white,), tooltip: AppLocalization.of(context).translate("Add Service"), onPressed: () => Navigator.of(context).pushNamed("/ServiceForm"))),
              ],
            ),
            body: user.userType == UserType.TECHNICIAN ? _widgetTech(context) : _widgetUser(context),
          );
        }

        return SizedBox();
      }
    );
  }

  Widget _widgetUser(context) {
    return StreamBuilder<List<ServiceModel>>(
      stream: FirebaseManager.shared.getServices(status: Status.ACTIVE),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          List<ServiceModel> services = snapshot.data;

          if (services.length == 0) {
            return Center(child: Text(AppLocalization.of(context).translate("No services have been added"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),));
          }

          return GridView.count(
            padding: EdgeInsets.all(10),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: List.generate(services.length, (index) {
              return InkWell(
                onTap: () => Navigator.of(context).pushNamed("/ServiceDetails", arguments: services[index].uid),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: Image.network(
                          services[index].images.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(lang == Language.ARABIC ? services[index].titleAR : services[index].titleEN, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w500,),)
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

          List<ServiceModel> services = snapshot.data;

          if (services.length == 0) {
            return Center(child: Text(AppLocalization.of(context).translate("You have not added any services"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),));
          }

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: services.length,
            itemBuilder: (context, index) {

              String statusTitle = "";
              Widget statusIcon = Icon(Icons.check, size: 22, color: Colors.green,);

              switch (services[index].status) {
                case Status.ACTIVE:
                  statusTitle = "Activity";
                  statusIcon = Icon(Icons.check, size: 22, color: Colors.green,);
                  break;
                case Status.PENDING:
                  statusTitle = "In Review";
                  statusIcon = Icon(Icons.access_time, size: 22, color: Colors.yellow,);
                  break;
                case Status.Rejected:
                  statusTitle = "Rejected";
                  statusIcon = Icon(Icons.report, size: 18, color: Colors.red,);
                  break;
              }

              return Column(
                children: [
                  SizedBox(height: 10),
                  Stack(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed("/ServiceDetails", arguments: services[index].uid),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * (100 / 375),
                                height: MediaQuery.of(context).size.width * (100 / 375),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                ),
                                child: Image.network(
                                  services[index].images.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 35),
                              Row(
                                children: [
                                  Text(AppLocalization.of(context).translate("Title: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                                  SizedBox(width: 10),
                                  Text(lang == Language.ARABIC ? services[index].titleAR : services[index].titleEN, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Text(AppLocalization.of(context).translate("Date created: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                                  SizedBox(width: 10),
                                  Text(services[index].createdDate.changeDateFormat(), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                                ],
                              ),
                              Visibility(
                                visible: services[index].status == Status.Rejected,
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Text(AppLocalization.of(context).translate("Reason of refuse: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                                        SizedBox(width: 10),
                                        Text(lang == Language.ARABIC ? services[index].messageAR : services[index].messageEN, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 35),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).primaryColor),
                                ),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      statusIcon,
                                      SizedBox(width: 10),
                                      Text(AppLocalization.of(context).translate(statusTitle), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(icon: Icon(Icons.delete_forever, size: 36, color: Colors.red,), tooltip: AppLocalization.of(context).translate("delete service"), onPressed: () {
                        showAlertDialog(context, title: AppLocalization.of(context).translate("Delete"), message: AppLocalization.of(context).translate("Are you sure delete service"), titleBtnOne: "Delete", titleBtnTwo: "Cancel", actionBtnOne: () {
                          Navigator.of(context).pop();
                          _deleteService(context, services[index].uid);
                        }, actionBtnTwo: () {
                          Navigator.of(context).pop();
                        });
                      })
                    ],
                  ),
                  SizedBox(height: 10),
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

  _deleteService(context, String idService) {
    FirebaseManager.shared.deleteService(context, idService: idService);
  }
}
