import 'package:flutter/material.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/loader.dart';
import 'package:maintenance/widgets/notifications.dart';
import 'package:maintenance/widgets/service-cell.dart';

class AllServicehidden extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("All Services")),
        centerTitle: true,
        actions: [
          NotificationsWidget(),
        ],
      ),
      body:  Column(
            children: [
            _header(),
            _footr(),
            Expanded(
            child: StreamBuilder<List<ServiceModel>>(
               stream: FirebaseManager.shared.getServices(status: Status.Rejected),
                   builder: (context, snapshot) {
                  if (snapshot.hasData) {
                List<ServiceModel> items = snapshot.data;
              return (items == null || items.length == 0) ? Center(child: Text(AppLocalization.of(context).translate("No services Rejected yet"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),),) : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ServiceCell(service: items[index], titleBtnOne:  AppLocalization.of(context).translate("Accept") , titleBtnTwo: AppLocalization.of(context).translate("Delete"), actionBtnOne: () {
                  FirebaseManager.shared.changeServiceStatus(_scaffoldKey.currentContext, service: items[index], status: Status.ACTIVE);
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
    )]));
  }
}

Widget _header() {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  return

    Expanded(
        key: _scaffoldKey,
        child: StreamBuilder<List<ServiceModel>>(
      stream: FirebaseManager.shared.getServices(status: Status.Deleted),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ServiceModel> items = snapshot.data;
          return (items == null || items.length == 0) ? Center(child: Text(AppLocalization.of(context).translate("No services Deleted yet"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),),) : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ServiceCell(service: items[index], titleBtnOne:  AppLocalization.of(context).translate("Accept") , titleBtnTwo: AppLocalization.of(context).translate("Delete"), actionBtnOne: () {
                FirebaseManager.shared.changeServiceStatus(_scaffoldKey.currentContext, service: items[index], status: Status.ACTIVE);
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
  ));
}

Widget _footr() {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  return
    Expanded(
        key: _scaffoldKey,
        child: StreamBuilder<List<ServiceModel>>(
            stream: FirebaseManager.shared.getServices(status: Status.Disable),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ServiceModel> items = snapshot.data;
                return (items == null || items.length == 0) ? Center(child: Text(AppLocalization.of(context).translate("No services Disable yet"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),),) : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ServiceCell(service: items[index], titleBtnOne:  AppLocalization.of(context).translate("Accept") , titleBtnTwo: AppLocalization.of(context).translate("Delete"), actionBtnOne: () {
                      FirebaseManager.shared.changeServiceStatus(_scaffoldKey.currentContext, service: items[index], status: Status.ACTIVE);
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
        ));
}
