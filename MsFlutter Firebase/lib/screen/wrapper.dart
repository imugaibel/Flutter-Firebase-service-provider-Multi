import 'package:flutter/material.dart';
import 'package:maintenance/Front/Front.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/main.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/screen/select_language.dart';
import 'package:maintenance/screen/signin.dart';
import 'package:maintenance/screen/tabbar/tabbar.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/choose-user-type.dart';

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
            return Front();
          }
        }
    );
  }
}

