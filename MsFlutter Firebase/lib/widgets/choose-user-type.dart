import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';

import 'alert.dart';

class ChooseUserType extends StatefulWidget {

  final String message;
  final UserType userType;

  const ChooseUserType({Key key, this.message, this.userType}) : super(key: key);
  @override
  _ChooseUserTypeState createState() => _ChooseUserTypeState();
}
class _ChooseUserTypeState extends State<ChooseUserType> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.message != null) {
      Future.delayed(Duration(seconds: 1), () {
        showAlertDialog(context, title: AppLocalization.of(context).translate("Done Successfully"), message: AppLocalization.of(context).translate(widget.message), showBtnOne: false, actionBtnTwo: () {
          Navigator.of(context).pop();
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pushNamed(context, '/Front'),
        ),
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (10 / 512),),
            Image.asset(Assets.shared.icLogo, fit: BoxFit.cover, height: MediaQuery.of(context).size.height * (150 / 812),),
            SizedBox(height: MediaQuery.of(context).size.height * (10 / 512),),
            Text(AppLocalization.of(context).translate("Choose user type"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32, fontWeight: FontWeight.w500,),),
            SizedBox(height: MediaQuery.of(context).size.height * (10 / 512),),
            _item(context, userType: UserType.ADMIN),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _item(context, userType: UserType.TECHNICIAN),
                _item(context, userType: UserType.USER),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(context, { @required UserType userType }) {

    String image;
    String title;

    switch (userType) {
      case UserType.ADMIN:
        image = Assets.shared.icAdmin;
        title = AppLocalization.of(context).translate("Admin");
        break;
      case UserType.TECHNICIAN:
        image = Assets.shared.icUserTechnician;
        title = AppLocalization.of(context).translate("Technician");
        break;
      case UserType.USER:
        image = Assets.shared.icUser;
        title = AppLocalization.of(context).translate("User");
        break;
    }
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed("/login", arguments: userType),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * (50 / 375),
            height: MediaQuery.of(context).size.width * (50 / 375),
            child: Center(child: SvgPicture.asset(image, fit: BoxFit.cover, width: MediaQuery.of(context).size.width * (50 / 375),)),
          ),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20,),),
        ],
      ),
    );
  }
}



