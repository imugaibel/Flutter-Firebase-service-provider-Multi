import 'package:flutter/material.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/model/service-model.dart';
import 'package:omni/model/user-model.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/utils/firebase-manager.dart';
import 'package:omni/utils/user_profile.dart';

class ServiceCell extends StatefulWidget {

  final ServiceModel service;
  final String titleBtnOne;
  final String titleBtnTwo;
  final bool isShowBtnOne;

  final Function actionBtnOne;
  final Function actionBtnTwo;

  const ServiceCell({Key key, @required this.service, @required this.titleBtnOne, this.isShowBtnOne = true, @required this.titleBtnTwo, @required this.actionBtnOne, @required this.actionBtnTwo}) : super(key: key);

  @override
  _ServiceCellState createState() => _ServiceCellState();
}

class _ServiceCellState extends State<ServiceCell> {

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
    return Column(
      children: [
        SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed("/ServiceDetails", arguments: widget.service.uid),
          child: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Image.network(
                          widget.service.images.first,
                          width: MediaQuery.of(context).size.width * 80 / 375,
                          height: MediaQuery.of(context).size.height * 80 / 812,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context).translate("User name: "),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                            FutureBuilder<UserModel>(
                              future: FirebaseManager.shared.getUserByUid(uid: widget.service.uidOwner),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.name,
                                    style:
                                    TextStyle(color: Colors.blueGrey, fontSize: 16),
                                  );
                                } else {
                                  return Text("");
                                }

                              }
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              AppLocalization.of(context).translate("Service name: "),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                            ),
                            Text(
                              lang == Language.ARABIC ? widget.service.titleAR.length < 15 ? widget.service.titleAR : widget.service.titleAR.substring(0, 15) + "..." : widget.service.titleEN.length < 15 ? widget.service.titleEN : widget.service.titleEN.substring(0, 15) + "...",
                              style:
                              TextStyle(color: Colors.blueGrey, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 40 / 812,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.isShowBtnOne,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: widget.actionBtnOne,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * (50 / 812),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                  child: Text(
                                    widget.titleBtnOne,
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  )),
                            ),
                          ),
                          SizedBox(width: 20,),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: widget.actionBtnTwo,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                              widget.titleBtnTwo,
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
  }
}
