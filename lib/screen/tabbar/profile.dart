import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/enums/profile.dart';
import 'package:maintenance/enums/user-type.dart';
import 'package:maintenance/main.dart';
import 'package:maintenance/model/user-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/assets.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/alert.dart';
import 'package:maintenance/widgets/notifications.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<ProfileList> items = [
    ProfileList.ABOUT_US,
    ProfileList.CHANGE_LANGUAGE,
    ProfileList.EDIT_PROFILE,
    ProfileList.EDIT_PASSWORD,
    ProfileList.WALLET,
    ProfileList.ORDERS,
    ProfileList.PRIVACY_TERMS,
    ProfileList.CONTACT_US,
    ProfileList.LOGOUT
  ];

  Future<UserModel?> user = UserProfile.shared.getUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user.then((value) {
      if (value!.userType != UserType.ADMIN) {
        items.remove(ProfileList.ORDERS);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context)!.translate("Profile")),
        centerTitle: true,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel?>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel? user = snapshot.data;

              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: user!.image != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(user.image),
                                          fit: BoxFit.cover)),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 52,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                          radius: 50,
                          backgroundColor: const Color(0xFFF0F4F8),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.userType == UserType.ADMIN
                                  ? AppLocalization.of(context)!
                                      .translate("admin")
                                  : user.userType == UserType.TECHNICIAN
                                      ? AppLocalization.of(context)!
                                          .translate("technician")
                                      : AppLocalization.of(context)!
                                          .translate("user"),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.height * (40 / 812)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _item(context,
                              item: items[index],
                              isLast: index == (items.length - 1));
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget _item(context, {required ProfileList item, bool isLast = false}) {
    String? title;
    String? screen;

    switch (item) {
      case ProfileList.ABOUT_US:
        title = "About us";
        screen = "/AboutUs";
        break;
      case ProfileList.CHANGE_LANGUAGE:
        title = "Change Language";
        break;
      case ProfileList.EDIT_PROFILE:
        title = "Edit Profile";
        screen = "/EditProfile";
        break;
      case ProfileList.EDIT_PASSWORD:
        title = "Edit Password";
        screen = "/EditPassword";
        break;
      case ProfileList.WALLET:
        title = "Wallet";
        screen = "/Wallet";
        break;
      case ProfileList.ORDERS:
        title = "Orders";
        screen = "/Orders";
        break;
      case ProfileList.PRIVACY_TERMS:
        title = "Privacy Terms";
        screen = "/PrivacyTerms";
        break;
      case ProfileList.CONTACT_US:
        title = "Contact US";
        screen = "/ContactUs";
        break;
      case ProfileList.LOGOUT:
        title = "Logout";
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () async {
          if (item == ProfileList.CHANGE_LANGUAGE) {
            changeLanguage(context);
          } else if (item == ProfileList.LOGOUT) {
            showAlertDialog(context,
                title: AppLocalization.of(context)!.translate("Logout"),
                message: AppLocalization.of(context)!
                    .translate("Are you sure to logout?"),
                titleBtnOne: "Logout",
                titleBtnTwo: "Close", actionBtnOne: () {
                  FirebaseManager.shared.signOut(context);
                }, actionBtnTwo: () {
                  Navigator.of(context).pop();
                });
          } else {
            await Navigator.of(context).pushNamed(screen!);
            setState(() {
              user = UserProfile.shared.getUser();
            });
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(context)!.translate(title),
                  style: TextStyle(
                      color:
                      isLast ? Colors.red : Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
  changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(Assets.shared.icEnglish),
                ),
                title: const Text('English'),
                onTap: () => _changeLanguage(context, lang: Language.ENGLISH),
              ),
              ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(Assets.shared.icArabic),
                ),
                title: const Text('عربي'),
                onTap: () => _changeLanguage(context, lang: Language.ARABIC),
              ),
            ],
          );
        });
  }

  _changeLanguage(context, {required Language lang}) async {
    MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    await UserProfile.shared.setLanguage(language: lang);
    Navigator.of(context).pop();
  }
}
