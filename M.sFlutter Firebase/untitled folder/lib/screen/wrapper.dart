import 'package:flutter/material.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/main.dart';
import 'package:omni/model/user-model.dart';
import 'package:omni/screen/select_language.dart';
import 'package:omni/screen/signin.dart';
import 'package:omni/screen/tabbar/tabbar.dart';
import 'package:omni/utils/user_profile.dart';
import 'package:omni/widgets/choose-user-type.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {

          Future.delayed(Duration.zero, () {

            UserProfile.shared.getLanguage().then((value) {
              MyApp.setLocale(context, Locale(value == Language.ARABIC ? "ar" : "en"));
            });

          });

          if (snapshot.hasData) {
            return TabBarPage(userType: snapshot.data.userType);
          } else {
            return SignIn();
          }
        }
    );
  }
}

