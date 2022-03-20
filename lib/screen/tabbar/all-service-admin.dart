import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';

import '../../widgets/service-cell.dart';

class AllServiceAdmin extends StatefulWidget {
  const AllServiceAdmin({Key? key}) : super(key: key);

  @override
  _AllServiceAdminState createState() => _AllServiceAdminState();
}

class _AllServiceAdminState extends State<AllServiceAdmin> {
  Language lang = Language.ENGLISH;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Status status = Status.PENDING;

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
        title: Text(AppLocalization.of(context)!.translate("All Services")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(),
            Expanded(
              child: FutureBuilder<UserModel?>(
                  future: UserProfile.shared.getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return StreamBuilder<List<ServiceModel>>(
                          stream: FirebaseManager.shared.getAllServices(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<ServiceModel> Services = [];
                              for (var service in snapshot.data!) {
                                if (service.status == status) {
                                  Services.add(service);
                                }
                              }
                              return Services.isEmpty
                                  ? Center(
                                      child: Text(
                                          AppLocalization.of(context)!
                                              .translate("No services yet"),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    )
                                  : ListView.builder(
                                      itemCount: Services.length,
                                      itemBuilder: (context, index) {
                                        return _item(context,
                                            service: Services[index]);
                                      },
                                    );
                            } else {
                              return Center(child: loader(context));
                            }
                          });
                    } else {
                      return Center(
                        child: loader(context),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalization.of(context)!.translate("Status Service:-"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.ACTIVE,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("active")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.PENDING,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("in review")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.Deleted,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("Deleted")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.Disable,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("disable")),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      activeColor: Theme.of(context).primaryColor,
                      value: Status.Rejected,
                      groupValue: status,
                      onChanged: (Status? value) {
                        setState(() {
                          status = value!;
                        });
                      },
                    ),
                    Text(AppLocalization.of(context)!.translate("rejected")),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _item(context, {required ServiceModel service}) {
    switch (service.status) {
      case Status.ACTIVE:
        break;
      case Status.PENDING:
        break;
      case Status.Deleted:
        break;
      case Status.Disable:
        break;
      case Status.Rejected:
        // TODO: Handle this case.
        break;
      case Status.Finished:
        // TODO: Handle this case.
        break;
      case Status.canceled:
        // TODO: Handle this case.
        break;
    }

    return ServiceCell(
      service: service,
    );
  }
}
