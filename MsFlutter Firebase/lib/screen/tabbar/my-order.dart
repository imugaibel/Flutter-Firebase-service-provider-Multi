import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/order-model.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/utils/extensions.dart';
import 'package:maintenance/widgets/notifications.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {

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
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("My Order")),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body: StreamBuilder<List<OrderModel>>(
        stream: FirebaseManager.shared.getMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            List<OrderModel> orders = snapshot.data;

            return orders.length == 0 ? Center(child: Text(AppLocalization.of(context).translate("You have no requests"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor)),) : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _item(context, order: orders[index]);
              },
            );
          } else {
            return Center(child: loader(context));
          }
        }
      ),
    );
  }

  Widget _item(context, { @required OrderModel order }) {

    String statusTitle = "";
    Widget statusIcon = Icon(Icons.check, size: 22, color: Colors.green,);

    switch (order.status) {
      case Status.ACTIVE:
        statusTitle = AppLocalization.of(context).translate("Activity");
        statusIcon = Icon(Icons.timer, size: 22, color: Colors.blue,);
        break;
      case Status.PENDING:
        statusTitle = AppLocalization.of(context).translate("In Review");
        statusIcon = Icon(Icons.update, size: 22, color: Colors.yellow,);
        break;
      case Status.Rejected:
        statusTitle = AppLocalization.of(context).translate("Rejected");
        statusIcon = Icon(Icons.report, size: 22, color: Colors.red,);
        break;
      case Status.Finished:
        statusTitle = AppLocalization.of(context).translate("Finished");
        statusIcon = Icon(Icons.check, size: 22, color: Colors.green,);
        break;
    }

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
                    Text(AppLocalization.of(context).translate("Service: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                    SizedBox(width: 10),
                    StreamBuilder<ServiceModel>(
                      stream: FirebaseManager.shared.getServiceById(id: order.serviceId),
                      builder: (context, snapshot) {
                        String serviceName = snapshot.hasData ? lang == Language.ARABIC ? snapshot.data.titleAR : snapshot.data.titleEN : "";
                        return Text(serviceName, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor));
                      }
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(AppLocalization.of(context).translate("Details"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                    SizedBox(width: 10),
                    Text(order.details, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                  ],
                ),
                Visibility(
                  visible: order.status == Status.Rejected,
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(AppLocalization.of(context).translate("Reason of refuse: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                          SizedBox(width: 10),
                          Text(lang == Language.ARABIC ? order.messageAR : order.messageEN, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(AppLocalization.of(context).translate("Date: "), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),),
                    SizedBox(width: 10),
                    Text(order.createdDate.changeDateFormat(), style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                  ],
                ),
                SizedBox(height: 15),
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
                        Text(statusTitle, style: TextStyle(fontSize: 16, color: Theme.of(context).accentColor),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
