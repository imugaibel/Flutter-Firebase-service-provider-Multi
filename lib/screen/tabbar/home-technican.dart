import 'package:flutter/cupertino.dart';
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
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/slider-home.dart';
import 'package:maintenance/utils/extensions.dart';

class HomeTechnican extends StatefulWidget {

  @override
  _HomeTechnicanState createState() => _HomeTechnicanState();
}

class _HomeTechnicanState extends State<HomeTechnican> {
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
        title: Text(AppLocalization.of(context).translate('Home')),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SliderHome(),
            FutureBuilder<UserModel>(
              future: UserProfile.shared.getUser(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {

                  UserModel user = snapshot.data;

                  return StreamBuilder<List<OrderModel>>(
                      stream: FirebaseManager.shared.getOrdersByStatus(status: Status.ACTIVE),
                      builder: (context, snapshot) {

                        if (snapshot.hasData) {

                          List<OrderModel> services = [];

                          for (var service in snapshot.data) {
                            if (service.ownerId == user.uid) {
                              services.add(service);
                            }
                          }

                          var heightItem = MediaQuery.of(context).size.height * (328 / 812);

                          return Container(
                            height: services.length == 0 ? heightItem : services.length * heightItem + 30,
                            child: services.length == 0 ? Center(child: Text(AppLocalization.of(context).translate("You have no requests in progress"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),)) : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(20),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                return _item(context, order: services[index]);
                              },
                            ),
                          );
                        } else {
                          return Center(child: loader(context));
                        }

                      }
                  );

                }

                return SizedBox();
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(context, { @required OrderModel order }) {
    return FutureBuilder<UserModel>(
      future: UserProfile.shared.getUser(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserModel user = snapshot.data;

          return Column(
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: () => Navigator.of(context).pushNamed("/OrderDetails", arguments: order),
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
                            stream: FirebaseManager.shared.getServiceById(id: order.serviceId),
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
                          Text(order.createdDate.changeDateFormat(), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                        ],
                      ),
                      SizedBox(height: 35),
                      InkWell(
                        onTap: () {
                          FirebaseManager.shared.changeOrderStatus(_scaffoldKey.currentContext, uid: order.uid, status: Status.Finished);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * (50 / 812),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                              child: Text(
                                AppLocalization.of(context).translate("End the service"),
                                style: TextStyle(color: Colors.green, fontSize: 18),
                              )),
                        ),
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
