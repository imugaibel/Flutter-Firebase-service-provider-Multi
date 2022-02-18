import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/comment_dialog.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/service-cell.dart';
import 'package:maintenance/widgets/slider-home.dart';
import 'package:maintenance/utils/extensions.dart';

class HomeAdmin extends StatefulWidget {

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  UserType dropDownUser = UserType.USER;
  List<String> dropDownUsers = [];

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
        child: Container(
          child: Column(
            children: [
              SliderHome(),
              StreamBuilder<List<ServiceModel>>(
                  stream: FirebaseManager.shared.getServices(status: Status.PENDING),
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {

                      List<ServiceModel> items = snapshot.data;

                      return items.length == 0 ? Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 100 / 812,),
                          Center(child: Text(AppLocalization.of(context).translate("There are no services for review"), style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),)),
                        ],
                      ) : Container(
                        height: items.length * (MediaQuery.of(context).size.height * 240 / 812),
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(20),
                          itemCount: items != null ? items.length : 0,
                          itemBuilder: (context, index) {
                            return ServiceCell(service: items[index], titleBtnOne: AppLocalization.of(context).translate("Accept"), titleBtnTwo: AppLocalization.of(context).translate("Reject"), actionBtnOne: () {
                              FirebaseManager.shared.changeServiceStatus(_scaffoldKey.currentContext, service: items[index], status: Status.ACTIVE);
                            }, actionBtnTwo: () {
                              commentDialog(context, titleBtn: AppLocalization.of(context).translate("Reject"), action: (commentEN, commentAR) async {
                                if (commentEN == "" || commentAR == "") {
                                  _scaffoldKey.showTosta(message: AppLocalization.of(context).translate("Please fill in all fields"), isError: true);
                                  return;
                                }
                                Navigator.of(context).pop();
                                FirebaseManager.shared.changeServiceStatus(_scaffoldKey.currentContext, service: items[index], status: Status.Rejected, messageEN: commentEN, messageAR: commentAR);
                              });
                            },);
                          },
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

}
