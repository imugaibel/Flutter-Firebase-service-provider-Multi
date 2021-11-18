import 'package:flutter/material.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/widgets/service-cell.dart';

class AllServiceAdmin extends StatelessWidget {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("All Services")),
        centerTitle: true,
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: FirebaseManager.shared.getServices(status: Status.ACTIVE),
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            List<ServiceModel> items = snapshot.data;

            return (items == null || items.length == 0) ? Center(child: Text(AppLocalization.of(context).translate("No services yet"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),),) : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ServiceCell(service: items[index], isShowBtnOne: false, titleBtnOne: "", titleBtnTwo: AppLocalization.of(context).translate("Delete"), actionBtnOne: () {

                }, actionBtnTwo: () {
                  showAlertDialog(context, title: AppLocalization.of(context).translate("Delete Service"), message: AppLocalization.of(context).translate("Are you sure to delete the service?"), titleBtnOne: "Delete", titleBtnTwo: "Close", actionBtnOne: () {
                    Navigator.of(context).pop();
                    FirebaseManager.shared.deleteService(_scaffoldKey.currentContext, idService: items[index].uid);
                  }, actionBtnTwo: () {
                    Navigator.of(context).pop();
                  });
                },);
              },
            );
          } else {
            return Center(child: loader(context));
          }

        }
      ),
    );
  }
}
