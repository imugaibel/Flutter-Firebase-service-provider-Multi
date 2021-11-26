import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/status.dart';
import 'package:maintenance/main.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';

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
        child: Text("Ms", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
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
          Navigator.of(context).pushNamedAndRemoveUntil("/Front", (route) => false, arguments: user.userType);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil("/Front", (route) => false);
        }
      });

    } else {
      Navigator.of(context).pushNamedAndRemoveUntil("/Front", (route) => false);
    }

  }

}
