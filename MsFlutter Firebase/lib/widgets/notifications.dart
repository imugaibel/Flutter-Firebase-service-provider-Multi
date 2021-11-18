import 'package:flutter/material.dart';
import 'package:maintenance/model/notification-model.dart';
import 'package:maintenance/utils/firebase-manager.dart';

class NotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationModel>>(
      stream: FirebaseManager.shared.getMyNotifications(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          List<NotificationModel> items = [];

          for (var item in snapshot.data) {
            if (!item.isRead) {
              items.add(item);
            }
          }

          return InkWell(
            onTap: () => Navigator.of(context).pushNamed("/Notification"),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Icon(Icons.notifications, color: Colors.white, size: 32,),
                  Visibility(
                    visible: items.length > 0,
                    child: Positioned(
                        top: -3,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(items.length.toString(), style: TextStyle(fontSize: 12),),
                        )),
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox();
        }

      }
    );
  }
}
