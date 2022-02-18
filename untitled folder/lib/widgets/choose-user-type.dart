import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omni/enums/user-type.dart';
import 'package:omni/utils/app_localization.dart';
import 'package:omni/utils/assets.dart';

class ChooseUserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (120 / 812),),
            Text(AppLocalization.of(context).translate("Choose user type"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32, fontWeight: FontWeight.w500,),),
            SizedBox(height: MediaQuery.of(context).size.height * (100 / 812),),
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
      onTap: () => Navigator.of(context).pushNamed("/SignIn", arguments: userType),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: MediaQuery.of(context).size.width * (120 / 375),
            height: MediaQuery.of(context).size.width * (120 / 375),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(child: SvgPicture.asset(image, fit: BoxFit.cover, width: MediaQuery.of(context).size.width * (80 / 375),)),
          ),
          SizedBox(height: 10),
          Text(title, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20,),),
        ],
      ),
    );
  }

}
