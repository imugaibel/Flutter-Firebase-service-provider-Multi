import 'package:flutter/material.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/enums/status.dart';
import 'package:omni/main.dart';
import 'package:omni/model/user-model.dart';
import 'package:omni/utils/assets.dart';
import 'package:omni/utils/firebase-manager.dart';
import 'package:omni/utils/user_profile.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      _wrapper();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(Assets.shared.icLogo, width: 225, height: 225, fit: BoxFit.cover,),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text("omni.com", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
      ),
    );
  }

  _wrapper() async {

    await UserProfile.shared.getLanguage().then((lang) {
      MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    });

    UserModel user = await UserProfile.shared.getUser();

    if (user != null) {

      FirebaseManager.shared.getUserByUid(uid: user.uid).then((user) {
        if (user.accountStatus == Status.ACTIVE) {
          Navigator.of(context).pushNamedAndRemoveUntil("/Tabbar", (route) => false, arguments: user.userType);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil("/SignIn", (route) => false);
        }
      });

    } else {
      Navigator.of(context).pushNamedAndRemoveUntil("/SignIn", (route) => false);
    }

  }

}
