import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omni/enums/language.dart';
import 'package:omni/main.dart';
import 'package:omni/utils/assets.dart';
import 'package:omni/utils/user_profile.dart';
import 'package:omni/widgets/btn-main.dart';

class SelectLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
            Expanded(child: SvgPicture.asset(Assets.shared.icTranslate)),
            SizedBox(height: MediaQuery.of(context).size.height * (60 / 812)),
            BtnMain(title: "English", onTap: () => _btnSelectLanguage(context, lang: Language.ENGLISH),),
            SizedBox(height: 20),
            BtnMain(title: "عربي", onTap: () => _btnSelectLanguage(context, lang: Language.ARABIC),),
          ],
        ),
      ),
    );
  }

  _btnSelectLanguage(context, { @required Language lang }) {
    MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    UserProfile.shared.setLanguage(language: lang);
    Navigator.of(context).pushReplacementNamed("/ChooseUserType");
  }

}
