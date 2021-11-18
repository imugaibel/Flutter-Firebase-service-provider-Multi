import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/notifications.dart';

class RequestServices extends StatefulWidget {
  @override
  _RequestServicesState createState() => _RequestServicesState();
}

class _RequestServicesState extends State<RequestServices> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Request Service")),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel>(
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            UserModel user = snapshot.data;

            return StreamBuilder<List<OrderModel>>(
                stream: FirebaseManager.shared.getOrdersByStatus(status: Status.PENDING),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    List<OrderModel> services = [];

                    for (var service in snapshot.data) {
                      if (service.ownerId == user.uid) {
                        services.add(service);
                      }
                    }

                    return services.length == 0 ? Center(child: Text(AppLocalization.of(context).translate("You have no new requests"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),) : ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return _item(context, item: services[index]);
                      },
                    );
                  } else {
                    return Center(child: loader(context));
                  }
                }
            );
          }
          return SizedBox();
        }
      )
    );
  }

  Widget _item(context, { @required OrderModel item }) {
    return FutureBuilder<UserModel>(
      future: FirebaseManager.shared.getUserByUid(uid: item.userId),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserModel user = snapshot.data;

          return Column(
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed("/OrderDetails", arguments: item),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(AppLocalization.of(context).translate("User name: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                          SizedBox(width: 10),
                          Text(user.name, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(AppLocalization.of(context).translate("Phone: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                          SizedBox(width: 10),
                          Text(user.phone, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(AppLocalization.of(context).translate("Service: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                          SizedBox(width: 10),
                          StreamBuilder<ServiceModel>(
                            stream: FirebaseManager.shared.getServiceById(id: item.serviceId),
                            builder: (context, snapshot) {
                              return Text(snapshot.hasData ? lang == Language.ARABIC ? snapshot.data.titleAR : snapshot.data.titleEN : "", style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor));
                            }
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(AppLocalization.of(context).translate("Date: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                          SizedBox(width: 10),
                          Text(item.createdDate.changeDateFormat(format: "yyyy-MM-dd - h:mm a"), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                        ],
                      ),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              FirebaseManager.shared.changeOrderStatus(_scaffoldKey.currentContext, uid: item.uid, status: Status.ACTIVE);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * (50 / 812),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                    AppLocalization.of(context).translate("Accept"),
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FirebaseManager.shared.changeOrderStatus(_scaffoldKey.currentContext, uid: item.uid, status: Status.Rejected);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * (50 / 812),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                    AppLocalization.of(context).translate("Reject"),

                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          );
        } else {
          return SizedBox();
        }

      }
    );
  }
}