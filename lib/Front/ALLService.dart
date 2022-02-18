import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/model/service-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';


class ALLService extends StatefulWidget {
  @override
  _ALLServiceState createState() => _ALLServiceState();
}
class _ALLServiceState extends State<ALLService> {
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
    return StreamBuilder<List<ServiceModel>>(
        stream: FirebaseManager.shared.getServices(status: Status.ACTIVE),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServiceModel> services = snapshot.data;

            if (services.length == 0) {
              return Center(child: Text(AppLocalization.of(context).translate(
                  "No services have been added"), style: TextStyle(color: Theme
                  .of(context)
                  .primaryColor, fontSize: 18),));
            }

            return GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: List.generate(services.length, (index) {
                return InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(
                          "/Wrapper"),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(12))
                          ),
                          child: Image.network(
                            services[index].images.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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

  }
