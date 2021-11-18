import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maintenance/enums/language.dart';
import 'package:maintenance/model/notification-model.dart';
import 'package:maintenance/utils/app_localization.dart';
import 'package:maintenance/utils/firebase-manager.dart';
import 'package:maintenance/utils/user_profile.dart';
import 'package:maintenance/widgets/loader.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {

  Language lang = Language.ENGLISH;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseManager.shared.setNotificationRead();
    UserProfile.shared.getLanguage().then((value) {
      setState(() {
        lang = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalization.of(context).translate("Notifications")),
        centerTitle: true,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: FirebaseManager.shared.getMyNotifications(),
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            List<NotificationModel> items = snapshot.data;

            items.sort((a,b) {
              return DateTime.parse(b.createdDate).compareTo(DateTime.parse(a.createdDate));
            });

            return items.length == 0 ? Center(child: Text(AppLocalization.of(context).translate("You have no notifications"), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),)) : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _item(item: items[index]);
              },
            );
          } else {
            return Center(child: loader(context));
          }

        }
      ),
    );
  }

  Widget _item({ @required NotificationModel item }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(lang == Language.ARABIC ? item.titleAr : item.titleEn, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w600),),
        SizedBox(height: 5),
        Text(lang == Language.ARABIC ? item.detailsAr : item.detailsEn, style: TextStyle(color: Colors.black54, fontSize: 16),),
        SizedBox(height: 10),
        Container(height: 1, color: Theme.of(context).primaryColor,),
        SizedBox(height: 10),
      ],
    );
  }

}
